//
//  MainViewController.swift
//  PoseFinder
//
//  Created by Vũ Phan on 20/08/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import CardSlider
struct Items: CardSliderItem{
    var image: UIImage
    
    var rating: Int?
    
    var title: String
    
    var subtitle: String?
    
    var description: String?
    
    
}

class MainViewController: UIViewController, CardSliderDataSource, UIGestureRecognizerDelegate {
    var data = [Items]()
    
    @IBOutlet var bottomBar: UIView!
    
    @IBOutlet var blurView: UIView!
    
    

    @IBOutlet var showTur: UIButton!
    @IBOutlet var tableView: UITableView!
    
    
    var listWorkouts = ["Squats","Standing dumbbell","Planks","Pushups"]
    var listPic = ["SQ","SD","PL","PU"]

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.append(Items(image: UIImage(named: "hi")!,
                          rating: 5,
                          title: "Chào bạn !",
                          subtitle: "Chúng tôi có thể giúp bạn cải thiện tập luyện đấy",
                          description: "Cơ thể chúng ta được thiết kế và phát triển để thường xuyên hoạt động.\n  Giống như cách mà một chiếc xe thể thao được thiết kế để đi nhanh,  cơ thể con người được thiết kế để di chuyển.\n  Và nếu chúng ta không hoạt động thì cơ thể sẽ càng ngày càng yếu đi và sức khỏe kém.\n  Để không mắc phải những điều đó thì ngay hôm nay hãy bắt đầu tập các bài workout đi.\n  Vậy tập workout có tác dụng gì hãy cùng đến phần tiếp theo để hiểu rõ hơn nhé!"))
        data.append(Items(image: UIImage(named: "SQ")!,
                          rating: 5,
                          title: "Squats",
                          subtitle: "Tư thế phô biển nhất để tập vòng 3",
                          description: "Tập Squat là tên gọi tiếng Anh của động tác ngồi xổm đặc trưng của người châu Á. Tư thế tập squat đúng cách “chuẩn” chính là hai chân mở rộng, đầu gối hướng sang hai bên, lưng thẳng, hạ hông xuống thấp nhưng đầu gối không vượt quá mũi chân.\n  Đối với những người mới làm quen với việc tập luyện, tập lần lượt các động tác và lặp lại chu kỳ 3 lần (3 hiệp).\n Đối với người có thể trạng tốt hoặc đã tập luyện lâu năm, có thể nâng số hiệp lên 5 đến 7 hiệp.\n Bước 1: Đứng thẳng, hai chân dang rộng, khoảng cách giữa hai chân rộng bằng vai.\n Bước 2: Hít vào. Duỗi lưng, đẩy lùi hông và mông về phía sau. Đầu gối mở rộng, hướng thẳng hàng với mũi chân. Cố gắng giữ cho đầu gối không vượt quá mũi chân để cơ đùi và hông phát triển.\n Bước 3: Thở ra và đứng lên, trở lại tư thế ở bước 1. Thực hiện động tác 20 lần."))
        data.append(Items(image: UIImage(named: "SD")!,
                          rating: 5,
                          title: "Standing dumbbell",
                          subtitle: "Hãy tập luyện với Dumbbell nào",
                          description: "Thực hiện bài tập Dumbbell Shoulder Press khá đơn giản và dễ thực hiện nếu như bạn nắm rõ kỹ thuật và chọn được mức tạ phù hợp. Khi tập bạn hãy áp dụng theo các bước sau:\n  Đầu tiên, bạn cần chọn cho mình 2 quả tạ với trọng lượng phù hợp và ngồi trên ghế tập vai chuyên dụng có tựa lưng, đặt tạ đứng trên 2 đùi. Bạn cũng lưu ý không nên chọn tạ có trọng lượng quá nhẹ vì nó sẽ không tác động tới cơ vai nhiều, và cũng không nên chọn trọng lượng tạ quá nặng vì như vậy có thể sẽ bị hỏng cơ và chấn thương khi luyện tập.Giữ lưng thẳng, đặt 2 chân chắc trên sàn tập rồi nâng tạ lên ngang vai từng cái một, dùng đùi để đẩy chúng lên vị trí đó. Xoay cổ tay để lòng bàn tay hướng về phía trước và đây cũng là vị trí bắt đầu của bài tập này.\n– Thở ra và đẩy đều tạ ở hai tay lên vị trí trên cùng, giữ nguyên vị trí cao nhất trong vòng 1-2 giây.\n– Từ từ hạ tạ xuống vị trí bắt đầu trong khi hít vào.\n– Lặp lại toàn bộ động tác để tiếp tục bài tập Dumbbell Shoulder Press cho tới khi đạt được số lần yêu cầu"))
        data.append(Items(image: UIImage(named: "PL")!,
                          rating: 5,
                          title: "Planks",
                          subtitle: "Một phút cũng đủ cho một ngày dài",
                          description: "Bài tập Plank là động tác nằm sấp, chống hai khuỷu tay vuông góc ngay dưới vai. Nhón hai mũi chân lên, nâng thân người lên và giữ lưng, hông, cổ thành một đường thẳng.  Đây là bài tập vua của vùng bụng, luyện tập sức bền của cơ bụng, giúp giảm mỡ bụng, luyện sức bền của cơ bắp tay và đùi.Quỳ gối xuống thảm. Ngả người về phía trước, chống hai tay xuống thảm, cánh tay vuông góc với cẳng tay, hai bàn tay nắm hờ đặt gần nhau hoặc đan vào nhau.Siết chặt cơ bụng sau đó kiểng hai mũi chân lên chạm sàn, đảm bảo hông và lưng tại thành một đường thẳng.\n - Lựa chọn dễ, giữ nguyên tư thế trong 30 giây đến 1 phút.\n - Lựa chọn khó, giữ nguyên tư thế trong 1 phút đến 1 phút 30 giây.\n - Lưu ý: Gồng chặt cơ bụng để bụng và hông thẳng hàng, không võng lưng xuống thấp."))
        data.append(Items(image: UIImage(named: "PU")!,
                          rating: 5,
                          title: "PushUps",
                          subtitle: "Độngt tác phổ biến nhất nam giới",
                          description: "Hít đất hay còn gọi là chống đẩy, là một động tác tập luyện thể chất bằng cách thực hiện nâng và hạ cơ thể liên tục bằng việc chống tay xuống đất.\nNằm sấp xuống mặt sàn hoặc thảm tập.\nHai chân duỗi thẳng, chụm lại với nhau, mũi chân chống xuống sàn hoặc thảm.\nHai tay chống xuống mặt sàn hoặc thảm.\nGiữ cho lưng được thẳng, dồn trọng lực về phần ngực.\n"))
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Workouts"
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(didTapMore))
        //navigationController?.navigationBar.isTranslucent = true
        //navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.barTintColor = UIColor.systemYellow
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 250
        tableView.backgroundColor = UIColor.clear
        
        
        showTur.layer.borderWidth = 1
        showTur.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        showTur.layer.opacity = 1
        showTur.layer.cornerRadius = showTur.frame.height / 2
        showTur.layer.shadowOpacity = 0.8
        showTur.layer.shadowOffset = CGSize(width: 0, height: 2)
        showTur.layer.shadowRadius = 5
        showTur.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        showTur.layer.opacity = 0.5
        
        

        
        bottomBar.layer.backgroundColor = UIColor.systemYellow.cgColor
        bottomBar.layer.borderColor = #colorLiteral(red: 1, green: 0.7310041785, blue: 0, alpha: 1)
        bottomBar.layer.borderWidth = 1
        bottomBar.layer.shadowRadius = 10
        bottomBar.layer.shadowOffset = .zero
        bottomBar.layer.shadowOpacity = 0.5
        bottomBar.layer.shadowColor = UIColor.black.cgColor


        bottomBar.layer.cornerRadius = 12
        
        
        
    }
    
    @objc private func didTapMore(){
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
    }
    
    @IBAction func didTapShowTur(_ sender: Any) {
        
        let vc = CardSliderViewController.with(dataSource: self)
        vc.modalPresentationStyle = .fullScreen
        //present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func item(for index: Int) -> CardSliderItem {
        return data[index]
    }
    
    func numberOfItems() -> Int {
        return data.count
    }
    
    
}
extension MainViewController : UITableViewDelegate{
    // make animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    static func makeSlideIn(duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }

    
    
    //pass data to View controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        vc?.title = listWorkouts[indexPath.row]
        vc?.nameWO = listWorkouts[indexPath.row]
        
        
        
    }
    
   
    
    
    
}
extension MainViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listWorkouts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        cell.contentView.backgroundColor = UIColor.clear
        let nameWO = listPic[indexPath.row]
        let nameLab = listWorkouts[indexPath.row]
        cell.myLab.text = nameLab
        cell.myImg.image = UIImage(named: nameWO)
        
        
        
        cell.myBGview.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.5)
        cell.myBGview.layer.cornerRadius = 10
        cell.myBGview.layer.shadowOpacity = 0.7
        cell.myBGview.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.myBGview.layer.shadowRadius = 3
        
        cell.myImg.layer.borderWidth = 3
        cell.myImg.layer.borderColor = #colorLiteral(red: 1, green: 0.8173077703, blue: 0, alpha: 1)
        cell.myImg.layer.cornerRadius = 10
        cell.myImg.clipsToBounds = true
        
        cell.myView.layer.cornerRadius = 10
        cell.myView.layer.shadowOpacity = 0.7
        cell.myView.layer.shadowOffset = CGSize(width: 0, height: -5)
        cell.myView.layer.shadowRadius = 3
   
        return cell
    }
    
    
}
//animation for cell
typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

final class Animator {
    private var animator: UIViewPropertyAnimator?
    private var hasAnimatedAllCells = false
    private let animation: Animation
    
    init(animation: @escaping Animation) {
        self.animation = animation
    }

    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }
        animator?.stopAnimation(true)
        if let animator = animator, animator.state != .inactive {
            animator.finishAnimation(at: .current)
        }

        animation(cell, indexPath, tableView)

      
    }
}
enum AnimationFactory {
    static func makeMoveUpWithFade(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, indexPath, _ in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight / 2)
            cell.alpha = 0

            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
            })
        }
    }
}


