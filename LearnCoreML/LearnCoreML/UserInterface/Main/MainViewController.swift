//
//  MainViewController.swift
//  LearnCoreML
//
//  Created by okamoto yuki on 2022/03/24.
//

import UIKit
import Vision  // TODO: このモジュールには依存しないようにする

class MainViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!

    private var classificationObservations: [VNClassificationObservation] = []    // TODO: 表示専用のクラス作る

    private let imagePicker = UIImagePickerController()
    private var imagePickerAlert: UIAlertController!


    override func viewDidLoad() {
        super.viewDidLoad()

        setupImagePicker()
        setupTableView()
    }


    @IBAction private func onTapCameraButton(_ sender: Any) {
        presentImagePickerIfAvailable(sourceType: .camera)
    }

    @IBAction private func onTapPhotoLibraryButton(_ sender: Any) {
        presentImagePickerIfAvailable(sourceType: .photoLibrary)
    }


    private func classifyObjects(image: UIImage) {
        let request = NetModel.shaerd.request(.mobileNetV2) { results in
            self.classificationObservations = results ?? []
            self.reloadTableView()
        }

        guard let ciImage = CIImage(image: image),
              let request = request else {
            return
        }

        do {
            try VNImageRequestHandler(ciImage: ciImage).perform([request])
        }
        catch {
            print(error)
        }
    }
}


extension MainViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else { return }
        imageView.image = image
        classifyObjects(image: image)
    }

    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false

        setupImagePickerAlert()
    }

    private func setupImagePickerAlert() {
        imagePickerAlert = UIAlertController(title: "環境設定", message: "カメラ／写真へのアクセスを許可してください", preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "設定", style: .default) { action in
            // アプリの設定を開く
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        imagePickerAlert.addAction(defaultAction)

        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            // do nothing
        }
        imagePickerAlert.addAction(cancelAction)
    }

    private func presentImagePickerIfAvailable(sourceType: UIImagePickerController.SourceType) {
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            // アクセス許可がない場合はアラートダイアログを表示
            present(imagePickerAlert, animated: true)
            return
        }

        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ClassificationTableViewCell", bundle: nil), forCellReuseIdentifier: "ClassificationTableViewCell")

        tableView.rowHeight = ClassificationTableViewCell.height
    }

    private func reloadTableView() {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classificationObservations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ClassificationTableViewCell()
        cell.configure(by: classificationObservations[indexPath.row])
        return cell
    }
}
