import SwiftUI

struct ImagePickerButton<Content: View>: View {
    
    // MARK: - Business logic properties

    @State private var showImagePickerSourceActionSheet = false
    @State private var showImagePickerSheet = false
    @State private var showImagePickerFullscreen = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    private let content: () -> Content
    private let selectedUIImage: Binding<UIImage?>
    private let onPickerDismiss: (() -> Void)?
    
    // MARK: - Object lifecycle
    
    init(selectedUIImage: Binding<UIImage?>, onPickerDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.selectedUIImage = selectedUIImage
        self.onPickerDismiss = onPickerDismiss
        self.content = content
    }
    
    // MARK: - View lifecycle
    
    var body: some View {
        button
            .sheet(isPresented: $showImagePickerSheet) {
                onPickerDismiss?()
            } content: {
                ImagePickerView(image: selectedUIImage, sourceType: imagePickerSourceType)
            }
            .fullScreenCover(isPresented: $showImagePickerFullscreen) {
                onPickerDismiss?()
            } content: {
                ImagePickerView(image: selectedUIImage, sourceType: imagePickerSourceType)
            }
    }
    
    // MARK: - Private properties
    
    @ViewBuilder
    private var button: some View {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            Button(action: { showImagePickerSourceActionSheet.toggle() }) {
                content()
            }
            .actionSheet(isPresented: $showImagePickerSourceActionSheet) {
                ActionSheet(
                    title: Text("ImagePickerButton.ActionSheet.Title"),
                    message: Text("ImagePickerButton.ActionSheet.Message"),
                    buttons: [
                        .default(Text("ImagePickerButton.ActionSheet.CameraButton.Title")) {
                            imagePickerSourceType = .camera
                            showImagePickerFullscreen.toggle()
                        },
                        .default(Text("ImagePickerButton.ActionSheet.LibraryButton.Title")) {
                            imagePickerSourceType = .photoLibrary
                            showImagePickerSheet.toggle()
                        }
                    ]
                )
            }
        } else {
            Button(action: { showImagePickerSheet.toggle() }) {
                content()
            }
        }
    }
}
