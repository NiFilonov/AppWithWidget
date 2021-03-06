//
//  RealmHelper.swift
//  AppWithWidget
//
//  Created by Dragonborn on 17.12.2020.
//

import Foundation
import RealmSwift
import WidgetKit

// RealmHelper - класс, через который мы работаем
// с базой данных Realm
class RealmHelper {
    
    // переменная, в которой будет объект Realm
    private var realm: Realm
    // ежедневная норма воды в миллилитрах
    private let dailyRate: Int = 2000
    
    init() {
        // берем FileManager, который позволяет управлять файлами
        let fileManager = FileManager.default
        // создаем путь для файла default.realm
        // путь создается до общей папки (AppGroup)
        let appGroupURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.water.contents")!
            .appendingPathComponent("default.realm")
        // проверяем доступен ли файл по этому пути
        if !fileManager.fileExists(atPath: appGroupURL.path) {
            // если в общей папке этот файл не найдет,
            // то начинаем оперцию переноса файла базы
            // данных Realm в общую папку

            // получаем текущее расположение файла default.realm
            let originalPath = Realm.Configuration.defaultConfiguration.fileURL!
            do{
                // если файл не был ранее перенесен это означает
                // что мы запускаем приложение в первый раз,
                // поэтому создаем нашу базу данных
                // создастся она в своей папке, внутри контейнера приложения
                let testRealm = try! Realm()
                // используя fileManager переносим нашу базу данных
                // в общую папку
                try _ = fileManager.replaceItemAt(appGroupURL, withItemAt: originalPath)
            }
            catch{
                print("Error info: \(error)")
            }
        }
        
        realm = try! Realm(fileURL: appGroupURL)
        
        // производим настройку базы данных
        configureRealm()
        
        // выводим путь к файлу базы данных
        print(realm.configuration.fileURL?.absoluteString ?? "error")
    }
    
    // функция, которая добавляет введенное пользователем
    // значение в поле ввода
    func addValue(_ value: Int) {
        // открываем базу данных для записи
        try! realm.write {
            // пытаемся получить объект из базы данных
            // так как он у нас один - берем first
            if let object = realm.objects(DayEntry.self).first {
                // вычитаем введенное пользователем значение
                // из текущего значения (которое отображено в зеленом
                // label'е)
                object.waterCount -= value
                
                // проверяем, если после вычета полученного значения
                // значение количества воды стало отрицательным -
                // воспринимаем это как будто пользователь
                // выпил ежедневную норму воды и обновляем
                // счетчик, снова установив дневную норму
                if object.waterCount < 0 {
                    object.waterCount = dailyRate
                }
            }
        }
        
        // Обновляем значения виджета после каждого изменения
        // в базе данных
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // функция, которая достает из базы данных значение
    // количества воды, которую нужно выпить для суточной
    // нормы
    func getValue() -> Int {
        // переменная куда будем писать результат
        var result: Int = 0
        
        // пытаемся получить объект из базы данных
        // так как он у нас один - берем first
        if let object = realm.objects(DayEntry.self).first {
            // если получилось достать объект из базы
            // данных записываем в result значение,
            // которое в нем хранится
            result = object.waterCount
        }
        // возвращаем значение с информацие об
        // оставшейся воде
        return result
    }
    
    // функция, которая настраивает базу данных.
    // настройка заключается в задании первого
    // значения для базы данных -
    // создании объекта DayEntry и сохранении
    // его в Realm.
    // Если в базе данных не будет этого
    // объекта, то нам не с чем будет рабоать
    private func configureRealm() {
        // пытаемся получить первый объект из базы данных
        if let _ = realm.objects(DayEntry.self).first {
            // если получили какой-то объект, значит все
            // хорошо, база данных уже сконфигурирована
            return
        } else {
            // если не получили, значит нужно добавить
            // в базу объект DayEntry.
            // открываем Realm для записи
            try! realm.write {
                // создаем объект DayEntry
                let dayObject = DayEntry()
                // присваиваем в него начальное значение
                // - ежедневная норма воды
                dayObject.waterCount = dailyRate
                // добавляем этот объект в Realm
                realm.add(dayObject)
            }
        }
    }
    
}
