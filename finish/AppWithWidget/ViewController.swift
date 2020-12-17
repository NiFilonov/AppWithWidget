//
//  ViewController.swift
//  AppWithWidget
//
//  Created by Dragonborn on 17.12.2020.
//

import UIKit

class ViewController: UIViewController {

    // поле ввода
    @IBOutlet weak var inputCountField: UITextField!
    // контейнер с полем ввода
    @IBOutlet weak var messageContainer: UIView!
    // кнопка добавить
    @IBOutlet weak var addButton: UIButton!
    // контейнер для информации об оставшейся норме воды
    @IBOutlet weak var infoContainer: UIView!
    // лэйбл, где выводится кол-во оставшейся воды
    @IBOutlet weak var remainingValueLabel: UILabel!
    
    // экземпляр хэлпера для базы данных
    private let database = RealmHelper()
    
    // тут, по сути, указываем что будет происходить
    // когда появится ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // запускаем настройку UI
        setupUI()
        // обновляем значение в remainingValueLabel
        updateRemainingValue()
    }

    @IBAction func addAction(_ sender: Any) {
        // проверяем введенные данные и можно ли
        // привести их к типу Int
        if checkInputText() {
            // приводим значение из текстового поля к типу Int
            let inputedValue = Int(inputCountField.text!)!
            // добавляем полученное значение в базу данных
            database.addValue(inputedValue)
            // очищаем поле ввода
            inputCountField.text = ""
            // обновляем значение оставшейся воды
            updateRemainingValue()
        }
    }
    
    // функция, которая обновляет значение оставшейся воды
    private func updateRemainingValue() {
        // получаем сколько мл воды надо еще выпить
        let newValue = database.getValue()
        // отображаем это значение в remainingValueLabel
        remainingValueLabel.text = "\(newValue)"
    }
    
    // функция, которая проверяет корректность введенных данных
    private func checkInputText() -> Bool {
        // получаем введенный текст
        let textFromTextField = inputCountField.text
        // переводим его в тип Int? - может быть опциональным
        let intValueOfInputedText = Int(textFromTextField!)
        
        // проверяем успешно ли конвертировался текст в тип Int
        // если введенное значение содержало не только цифры,
        // то значение intValueOfInputedText будет nil
        if intValueOfInputedText == nil {
            // возвращаем результат
            return false
        }
        
        // возвращаем результат
        return true
    }
    
    // функция, которая настраивает UI
    private func setupUI() {
        // скругляем углы у кнопки и контейнеров
        messageContainer.layer.cornerRadius = 20.0
        addButton.layer.cornerRadius = 20.0
        infoContainer.layer.cornerRadius = 20.0
        
        // задаем тени для контейнеров
        messageContainer.layer.shadowColor = UIColor.black.cgColor
        messageContainer.layer.shadowRadius = 14.0
        messageContainer.layer.shadowOffset = .zero
        messageContainer.layer.shadowOpacity = 0.6
        
        infoContainer.layer.shadowColor = UIColor.black.cgColor
        infoContainer.layer.shadowRadius = 14.0
        infoContainer.layer.shadowOffset = .zero
        infoContainer.layer.shadowOpacity = 0.6
    }
    
}

