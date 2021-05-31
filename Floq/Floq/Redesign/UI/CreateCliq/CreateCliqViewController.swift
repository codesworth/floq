import UIKit
import Combine

private enum Constant {
    static let regularFontSize: CGFloat = 18
    static let cliqNameFontSize: CGFloat = 24
    static let cliqButtonFontSize: CGFloat = 36
    static let cornerRadius: CGFloat = 5
    static let coverImageHeight: CGFloat = (UIScreen.height - (UIScreen.main.hasNotch ? 80 : 60)) * 0.5
    static let overLayHeight: CGFloat = 80
    static let textFieldHeight: CGFloat = 40
}


class CreateCliqViewController: UIViewController, Insetable{
    
    private var cancellables = Set<AnyCancellable>()
    private let imagePicker = UIImagePickerController()
    
    private let coverImageView = UIImageView()
    private let coverButton = UIButton()
    private let cliqNameTextLabel = UITextField()
    private let cliqNameOverlay = UIView()
    private var cliqDetailInfoLabel:UILabel!
    private let addCliqButton = UIButton()
    private var loadingView: LoaderView!
    
    private var viewModel: CreateCliqViewModelProtocol
    
    init(with viewModel: CreateCliqViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        addConstraints()
        bind()
    }
    
    private func bind(){
        viewModel.createCliqListener.sink { [weak self] completion in
            switch completion {
            case .failure(let err):
                if err.errorType == .locationUnAvailble {
                    self?.showUnAvailableLocationAlert(message: err.errorMessage)
                    self?.loadingView.removeFromSuperview()
                    return
                }
                SnackBar.makeSncakMessage(text: err.description)
            case .finished: break
            }
        } receiveValue: { [weak self] _ in
            SnackBar.makeSncakMessage(text: "Your cliq was succesfully created", color: .seafoamBlue)
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)

    }
    
    private func showUnAvailableLocationAlert(message: String){
        let alert = UIAlertController.createDefaultAlert("INFO", message,.alert, "OK",.default,tintColor: .black, nil)
        let settings = UIAlertAction(title: "Settings", style: .default){_ in UIApplication.openSettings()}
        alert.addAction(settings)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func createCliq(){
        let image = coverImageView.image
        let name = cliqNameTextLabel.text.exact
        
        guard name.count > 4 else {
            present(UIAlertController.createDefaultAlert("INFO", "Cliq title should contain 5 or more characters",.alert, "OK",.default,tintColor:.black, nil), animated: true, completion: nil)
            return
        }
        
        guard let data = image?.dataFromJPEG() else {
            present(UIAlertController.createDefaultAlert("INFO", "Please add a cover image",.alert, "OK",.default, tintColor:.black, nil), animated: true, completion: nil)
            return
        }
        
        viewModel.createCliq(name: name, coverImageData: data)
        loadingView = LoaderView(frame: self.view.bounds)
        loadingView.label.text = "Creating Cliq, Please wait..."
        self.view.addSubview(loadingView)
    }
    
    @objc private func imagePickerAlert(){
        
        let alert = UIAlertController.createDefaultAlert("Add Cover Photo", "",.actionSheet, "Take photo") { [weak self ] (action) in
            guard let self = self else { return }
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
            self.imagePicker.delegate = self
        }
        let action2 = UIAlertAction(title: "Photo Library", style: .default) { [weak self ] (action) in
            guard let self = self else { return }
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(action2)
        alert.addAction(action3)
        alert.view.tintColor = .black
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancellables.forEach{ $0.cancel() }
    }
}

extension CreateCliqViewController {
    private func initializeView(){
        view.backgroundColor = .black
        title = "create_cliq_title".localize()
        coverImageView.setup(with: nil, contentMode: .scaleToFill)
        coverButton.titleLabel?.font = .systemFont(ofSize: Constant.regularFontSize, weight: .regular)
        coverButton.setTitle("create_cliq_add_cover".localize(), for: .normal)
        coverButton.addTarget(self, action: #selector(imagePickerAlert), for: .touchUpInside)
        
        cliqNameTextLabel.font = .systemFont(ofSize: Constant.cliqNameFontSize, weight: .regular)
        cliqNameTextLabel.textColor = .white
        cliqNameTextLabel.attributedPlaceholder = "create_cliq_placeholder".localize().attributing([.textColor(.white)])
        cliqNameTextLabel.autocorrectionType = .no
        cliqNameTextLabel.returnKeyType = .done
        cliqNameTextLabel.delegate = self
        
        cliqNameOverlay.backgroundColor = .cloudyBlue
        
        cliqDetailInfoLabel = .makeLabel(font: .systemFont(ofSize: Constant.regularFontSize, weight: .regular), textColor: .white, alignment: .center)
        cliqDetailInfoLabel.text = "create_cliq_notice_info".localize()
        
        addCliqButton.backgroundColor = .pear
        addCliqButton.setTitleColor(.black, for: .normal)
        addCliqButton.setTitle("create_cliq_button_create".localize(), for: .normal)
        addCliqButton.titleLabel?.font = .systemFont(ofSize: Constant.cliqButtonFontSize, weight: .regular)
        addCliqButton.dropCorner(Constant.cornerRadius)
        addCliqButton.addTarget(self, action: #selector(createCliq), for: .touchUpInside)
        
        view.addSubview(coverImageView)
        view.addSubview(coverButton)
        view.addSubview(cliqNameOverlay)
        view.addSubview(cliqNameTextLabel)
        view.addSubview(cliqDetailInfoLabel)
        view.addSubview(addCliqButton)
    }
    
    private func addConstraints(){
        coverImageView.layout{
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.top == view.topAnchor
            $0.height |=| Constant.coverImageHeight
        }
        
        coverButton.layout{
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.top == view.topAnchor
            $0.bottom == cliqNameOverlay.topAnchor
        }
        
        cliqNameOverlay.layout{
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.bottom == coverImageView.bottomAnchor
            $0.height |=| Constant.overLayHeight
        }
        
        cliqNameTextLabel.layout{
            $0.leading == view.leadingAnchor + horizontalInset
            $0.trailing == view.trailingAnchor - horizontalInset
            $0.centerY == cliqNameOverlay.centerYAnchor
            $0.height |=| Constant.textFieldHeight
        }
        
        cliqDetailInfoLabel.layout{
            $0.leading == view.leadingAnchor + doubleHorizontalInset
            $0.trailing == view.trailingAnchor - doubleHorizontalInset
            $0.top == cliqNameOverlay.bottomAnchor + horizontalInset
            $0.bottom == addCliqButton.topAnchor - verticalInset
        }
        
        addCliqButton.layout{
            $0.leading == view.leadingAnchor + horizontalInset
            $0.trailing == view.trailingAnchor - horizontalInset
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor - doubleVerticalInset
            $0.height |=| Constant.overLayHeight
        }
        
    }
}


extension CreateCliqViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
}


extension CreateCliqViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage{
            coverImageView.image = image
            coverButton.setTitle("", for: .normal)
        }
    }
}
