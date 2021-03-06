//
//  TabBarViewController.swift
//  BNCommon
//
//  Created by Grzegorz Jurzak on 12/02/2019.
//  Copyright © 2019 HYD. All rights reserved.
//

import ReMVVM
import RxCocoa
import RxSwift
import UIKit

class TabBarViewController: UIViewController, ReMVVMDriven {

    @IBOutlet private var tabBarStackView: UIStackView!

    private var disposeBag = DisposeBag()

    override var childForStatusBarStyle: UIViewController? {
        return findNavigationController()?.topViewController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let viewModel: TabBarViewModel = remvvm.viewModel(for: self) else { return }
        bind(viewModel)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = DisposeBag()
    }

    private func bind(_ viewModel: TabBarViewModel) {

        viewModel.tabBarItemsViewModels
            .map { $0.map { TabBarItemView.loadViewFromNib(with: $0) } }
            .bind(to: tabBarStackView.rx.items)
            .disposed(by: disposeBag)
    }

}

extension Reactive where Base: UIStackView {

    var items: Binder<[UIView]> {
        return Binder(base) { stackView, views in
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            views.forEach { stackView.addArrangedSubview($0) }
        }
    }
}
