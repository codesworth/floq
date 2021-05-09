//
//  CommentsVC.swift
//  Floq
//
//  Created by Shadrach Mensah on 17/07/2019.
//  Copyright © 2019 Arun Nagarajan. All rights reserved.
//

import UIKit

class CommentsVC: UIViewController {
    
    private lazy var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.isScrollEnabled = true
        table.alwaysBounceVertical = true
        table.register(UINib(nibName: CommentAlternateCell.Identifier, bundle: nil), forCellReuseIdentifier: CommentAlternateCell.Identifier)
        table.register(UINib(nibName: "\(CommentCell.self)", bundle: nil), forCellReuseIdentifier: "\(CommentCell.self)")
        table.register(UINib(nibName: "\(LoadMoreCells.self)", bundle: nil), forCellReuseIdentifier: "\(LoadMoreCells.self)")
        return table
    }()
    
    private var keyboardoffset:CGFloat = 0
    private var cliqID:String!
    private var tap:UITapGestureRecognizer?
    var photoID:String!
    var isMessageBoard = false
    private var engine: CommentEngine!
    let notificationEngine = CommentNotificationEngine()
    var exhausted = false
    var hasNotch:Bool = false
    private var originalTextFrame:CGRect = .zero
    
    private var bottomConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!

    private lazy var commentTextBox:UITextField = {
        let textField = UITextField(frame: .zero)
        textField.font = .systemFont(ofSize: 14, weight: .regular)
        textField.textColor = .darkGray
        textField.placeholder = "Comment..."
        textField.borderStyle = .line
        textField.backgroundColor = .red
        return textField
    }()
    
    private lazy var commentInput:CommentsInputView = { [unowned self] by in
        let view = CommentsInputView(frame: .zero)
        view.isHidden = false
        view.delegate = self
        return view
    }(())
    
    private var mock:Comment.MockData = Comment.MockData()
    
    init(id:String, _ hasNotch:Bool, cliqID:String,isMessageBoard:Bool){
        super.init(nibName: nil, bundle: nil)
        photoID = id
        self.isMessageBoard = isMessageBoard
        self.hasNotch = hasNotch
        self.cliqID = cliqID
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = isMessageBoard ? "Message Board" : "Comments"
        App.setDomain(.Comment)
        engine = CommentEngine(photoOrCliq: photoID, isMessageBoard: isMessageBoard)
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(commentInput)
        layout()
        watchComments()
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.addSubview(commentInput)
        tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap?.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap!)
        navigationItem.backBarButtonItem?.title = ""
        // Do any additional setup after loading the view.
    }
    
    
    @objc func tapped(_ recognizer:UITapGestureRecognizer){
        commentInput.textView.resignFirstResponder()
    }
    
    
    func watchComments(){
        engine.watchForComments { (err) in
            if err != nil{
                SmartAlertView(text: err!.localizedDescription).show(5)
            }else{
                self.exhausted = self.engine.exhausted
                self.tableView.reloadData()
                
            }
        }
    }
    
    func layout(){
        let inset:CGFloat = hasNotch ? 20 : -10
        commentInput.layout(true){
                    $0.leading == view.leadingAnchor + 12
                    $0.trailing == view.trailingAnchor - 12
                   bottomConstraint = $0.bottom == view.safeAreaLayoutGuide.bottomAnchor
                   heightConstraint = $0.height |=| 38
                }
        
        tableView.layout{
            $0.top == view.topAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.bottom == commentInput.topAnchor
        }
        //commentView.titleEdgeInsets = hasNotch ? UIEdgeInsets(top: 0, left: 0, bottom: 20, right:  0) : UIEdgeInsets.zero
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //commentInput.textView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        App.setDomain(.Comment)
        notificationEngine.endHightlightFor(cliq:cliqID)
        //let inset:CGFloat = hasNotch ? 40 : 0
        //tableView.frame = CGRect(origin: view.frame.origin, size: CGSize(width: view.frame.width, height: view.frame.height - (60 + inset)))

    }
    
    
    @objc func commentPressed(_ sender:UIButton){
        let commentvc = AddCommentVC(hasNotch)
        commentvc.delegate = self
        parent?.present(commentvc, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let height = value.cgRectValue.height
            bottomConstraint.constant = -height
            UIView.animate(withDuration: 0.8, animations: {
                self.view.layoutIfNeeded()
                
                })
            if let tap = tap{
                view.addGestureRecognizer(tap)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let height = value.cgRectValue.height
            keyboardoffset = height
            UIView.animate(withDuration: 0.8) {
                self.view.layoutIfNeeded()
            }
            if let tap = tap{
                view.removeGestureRecognizer(tap)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension CommentsVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if engine.comments.isEmpty{

            let lable = UILabel(frame: tableView.frame)
            lable.text = "Be the first to comment..."
            lable.textAlignment = .center
            lable.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            lable.textColor = .darkGray
            tableView.backgroundView = lable
        }else{
            tableView.backgroundView = nil
        }
        if exhausted{
            return engine.comments.count
        }else{
            return engine.comments.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == engine.comments.endIndex{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(LoadMoreCells.self)", for: indexPath) as? LoadMoreCells{
                cell.reset()
                return cell
            }
        }
        
        let comment = engine.comments[indexPath.row]
        if comment.commentorID != UserDefaults.uid{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(CommentCell.self)", for: indexPath) as? CommentCell{
                
                cell.configure(comment)
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(CommentAlternateCell.self)", for: indexPath) as? CommentAlternateCell{
                
                cell.configure(comment)
                return cell
            }
        }
        
        return CommentCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == engine.comments.endIndex{
            return 40
        }
        let comment = engine.comments[indexPath.row]
        let width = tableView.frame.width - 62
        let txtheight = comment.body.height(withConstrainedWidth: width, font: .systemFont(ofSize: 13, weight: .regular))
        return txtheight + 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == engine.comments.endIndex{
            if let cell = tableView.cellForRow(at: indexPath) as? LoadMoreCells{
                cell.pressed()
                watchComments()
            }
        }
    }
    
}


//FOr testing Remove at integration Testing

extension CommentsVC:CommentProtocol{
    func didPost(_ comment: String) {
        
        SmartAlertView(text: "Sending comment....").show()
        //return
        if let _ = App.user{
            let raw = Comment.Raw(ref: nil, body: comment, photoID: photoID,cliqID: cliqID)
            engine.postAComment(raw) { (err) in
                if err != nil{
                   SmartAlertView(text: err!.localizedDescription).show()
                }else{
                    self.tableView.reloadData()
                }
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DataService.main.updatelastInteraction()
    }
    
}


extension CommentsVC:CommentInputViewDelegate{
    
    func adjustFrame(_ height:CGFloat) {
            heightConstraint.constant = height
            UIView.animate(withDuration: 0.35) {
                self.view.layoutIfNeeded()
            }
        }

    
    func postTapped(_ text: String) {
        if let _ = App.user{
            commentInput.textView.text = ""
            commentInput.textViewDidChange(commentInput.textView)
            let raw = Comment.Raw(ref: nil, body: text, photoID: photoID, cliqID: cliqID)
            engine.postAComment(raw) { (err) in
                if err != nil{
                    SmartAlertView(text: err!.localizedDescription).show()
                }else{
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    
}
