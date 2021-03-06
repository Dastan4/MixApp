//
//  ItemDetailViewController.swift
//  MixApp
//
//  Created by Dastan Mambetaliev on 22/2/21.
//

import UIKit

//прописываем то, что необходимо будет реализовать в вызываемом классе
protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {

    weak var delegate: ItemDetailViewControllerDelegate?
//    добавляем для дальнейшего изменения данных в таблице
    weak var todoList: TodoList?
    weak var itemToEdit: ChecklistItem?
    
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var addBarButtom: UIBarButtonItem!
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    //    настройка кнопки cancel на выход на предыдущий view
    @IBAction func cancel(_ sender: Any) {        delegate?.itemDetailViewControllerDidCancel(self)
    }
//    какое из условий сохраняет новое значение?
    @IBAction func done(_ sender: Any) {
//        изменение ячейки
//        если произошли изменения, то он отправляет измененный объект обратно в
//        CheckListItemViewController
        if let item = itemToEdit, let text = textfield.text, let descFieldText = descriptionTextField.text {
            item.text = text
            item.desc = descFieldText
//            метод с помощью которого он отправляет измененый объект
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
//            создание новой ячейки
            if let item = todoList?.newTodo() {
                if let textFieldText = textfield.text, let descFieldText = descriptionTextField.text {
                    item.text = textFieldText
                    item.desc = descFieldText
                }
                item.checked = false
                delegate?.itemDetailViewController(self, didFinishAdding: item)
                todoList?.updateData()
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //изменение названия страницы на Edit Item при изменении и передача текста из прошлой записи
        if let item = itemToEdit {
            title = "Edit Item"
            textfield.text  = item.text
            descriptionTextField.text = item.desc
        }
//Перевод тайтлов в более крупный вид
        navigationItem.largeTitleDisplayMode = .never
//        первый способ использования делегатов
//
        textfield.delegate = self
        descriptionTextField.delegate = self
        navigationItem.largeTitleDisplayMode = .never
    }
//    автоматический вызов клавиатуры
    override func viewWillAppear(_ animated: Bool) {
        textfield.becomeFirstResponder()
    }
    
//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        return nil
//    }
}


extension ItemDetailViewController: UITextFieldDelegate {
    
//вызывает keyboard при edit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.becomeFirstResponder()
        return false
    }
//проверяет если произошли изменения, то активирует done button
//    isEmpty - если строка пустая
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        doneButton.isEnabled = textField.text?.isEmpty ?? true ? false : true
        return true
    }
    
}

