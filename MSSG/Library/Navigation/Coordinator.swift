//
//  Coordinator.swift
//  RYAH
//
//  Created by Max Rozdobudko on 3/1/19.
//  Copyright © 2019 RYAH MEDTECH INC. All rights reserved.
//

import Foundation

class BaseCoordinator<Value> {

    typealias Completion = (_ result: Value) -> ()

    // MARK: Manage child coordinators

    private var children: [UUID: Any] = [:]

    private let identifier = UUID()

    private func hold<T>(coordinator: BaseCoordinator<T>) {
        children[coordinator.identifier] = coordinator
    }

    private func free<T>(coordinator: BaseCoordinator<T>) {
        children.removeValue(forKey: coordinator.identifier)
    }

    // MARK: API

    func coordinate<T>(to coordinator: BaseCoordinator<T>, with completion: @escaping (T) -> ()) {
        hold(coordinator: coordinator)

        coordinator.start { [weak self] value in
            completion(value)
            self?.free(coordinator: coordinator)
        }
    }

    func start(with completion: @escaping Completion) {
        fatalError("BaseCoordinator.start() method should be implemented in subclass.")
    }
}
