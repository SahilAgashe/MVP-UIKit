//
//  MVP.swift
//  MyApp
//
//  Created by SAHIL AMRUT AGASHE on 29/04/24.
//

import UIKit

// MARK: - ViewController

class ViewController: UIViewController {
    
    var label = UILabel()
    
    let service = Service()
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        service.fetchNumber { [weak self] number in
            let formatted = self?.formatter.string(for: number)
            self?.label.text = formatted
        }
    }
    
    // responsibilities of ViewController =>
    // handle lifecycle of UIViewController // ok
    // fetch the data from the correct place // can move out
    // format the data // can move out
    // display the data // ok
}


// MARK: - Model View ViewModel (MVVM)

class ViewController1: UIViewController {
    
    var label = UILabel()

    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.updateUI = { [weak self] newData in
            self?.label.text = newData
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
    }
    
    // responsibilities of ViewController1 =>
    // handle lifecycle of UIViewController // ok
    // display the data // ok
    
    // responsibilities of ViewModel (here ViewModel to View Binding)
    // fetch the data from the correct place
    // format the data
    // You can also add view to ViewModel Binding!
}

class ViewModel {
    let service = Service()
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter
    }()
    
    var updateUI: ((_ newDataToDisplay: String?) -> Void)?
    
    func fetchData() {
        service.fetchNumber { [weak self] number in
            let formatted = self?.formatter.string(for: number)
            self?.updateUI?(formatted)
        }
    }
}

// MARK: - Model View Presenter (MVP)

class ViewController2: UIViewController {
    var label = UILabel()

    var presenter: Presenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = Presenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchData()
    }
}

extension ViewController2: PresenterView {
    func display(newData: String?) {
        label.text = newData
    }
}

protocol PresenterView: AnyObject {
    func display(newData: String?)
}

class Presenter {
    let service = Service()
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter
    }()
    
    weak var view: PresenterView?
    
    init(view: PresenterView) {
        self.view = view
    }
    
    func fetchData() {
        service.fetchNumber { [weak self] number in
            let formatted = self?.formatter.string(for: number)
            self?.view?.display(newData: formatted)
        }
    }
}

// MARK: - Service

class Service {
    func fetchNumber(_ completion: (Int) -> Void) {}
}


