import Foundation



class CreateCliqMapper{
    
    func map(model: CreateCliqPresentationModel) -> CreateCliqDataModel {
        .init(
            name: model.name,
            imageData: model.imageData,
            location: model.coordinate
        )
    }
}
