//
//  DayModel.swift
//  AppWithWidget
//
//  Created by Dragonborn on 18.12.2020.
//

import Foundation
import RealmSwift

// объект, который будет хранить в себе информацию о
// том, сколько еще нужно выпить воды

// наследование от Object необходимо, чтобы наша
// база данных Realm могла работать с этим
// объектом

// @obj dynamic - тоже необходимость для работы с
// Realm'ом
class DayEntry: Object {
    @objc dynamic var waterCount: Int = 0
}
