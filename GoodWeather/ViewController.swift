//
//  ViewController.swift
//  GoodWeather
//
//  Created by Mehmet  Kulakoğlu on 13.10.2022.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { city in
                if let city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
    }

    private func fetchWeather(by city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL.urlForWeatherAPI(city: cityEncoded) else { return }
        
        let resource = Resource<WeatherResult>(url: url)
        
        // Without error handling
//        let search = URLRequest.load(resource: resource)
//            .observeOn(MainScheduler.instance)
//            .asDriver(onErrorJustReturn: WeatherResult.empty)
        
        //With catchError
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
        //With retry (Optinal)
            .retry(3)
            .catchError { error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            }.asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map { "\($0.main.temp) ℉" }
            .drive(self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map { "\($0.main.humidity) 💨" }
            .drive(self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
            
    }

    private func displayWeather(_ weather: Weather?) {
        if let weather {
            self.temperatureLabel.text = "\(weather.temp) ℉"
            self.humidityLabel.text = "\(weather.humidity) 💨"
        } else {
            self.temperatureLabel.text = "🙈"
            self.humidityLabel.text = "⛔️"
        }
    }
}

