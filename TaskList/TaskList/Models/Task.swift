//
//  Task.swift
//  TaskList
//
//  Created by Mauricio Esteves on 2020-08-11.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
