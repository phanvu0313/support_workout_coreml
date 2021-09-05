/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation details of a view that visualizes the detected poses.
*/

import UIKit

@IBDesignable
class PoseImageView: UIImageView {

    /// A data structure used to describe a visual connection between two joints.
    struct JointSegment {
        let jointA: Joint.Name
        let jointB: Joint.Name
    }
    var name = ""
    

    /// An array of joint-pairs that define the lines of a pose's wireframe drawing.
    static let jointSegments = [
        // The connected joints that are on the left side of the body.
        //JointSegment(jointA: .leftHip, jointB: .leftShoulder),
        JointSegment(jointA: .leftShoulder, jointB: .leftElbow),
        JointSegment(jointA: .leftElbow, jointB: .leftWrist),
        JointSegment(jointA: .leftHip, jointB: .leftKnee),
        JointSegment(jointA: .leftKnee, jointB: .leftAnkle),
        // The connected joints that are on the right side of the body.
        //JointSegment(jointA: .rightHip, jointB: .rightShoulder),
        
        JointSegment(jointA: .rightShoulder, jointB: .rightElbow),
        JointSegment(jointA: .rightElbow, jointB: .rightWrist),
        JointSegment(jointA: .rightHip, jointB: .rightKnee),
        JointSegment(jointA: .rightKnee, jointB: .rightAnkle),
        // The connected joints that cross over the body.
        JointSegment(jointA: .leftShoulder, jointB: .rightShoulder),
        JointSegment(jointA: .leftHip, jointB: .rightHip)
    ]
    //JointSegment(jointA: .leftShoulder, jointB: .middleShoulder),
    //JointSegment(jointA: .leftHip, jointB: .centerBody),
    
    // The connected joints that are on the right side of the body.
    //JointSegment(jointA: .rightHip, jointB: .rightShoulder),
    //JointSegment(jointA: .rightShoulder, jointB: .middleShoulder),
    //JointSegment(jointA: .rightHip, jointB: .centerBody),

    /// The width of the line connecting two joints.
    @IBInspectable var segmentLineWidth: CGFloat = 2
    /// The color of the line connecting two joints.
    @IBInspectable var segmentColor: UIColor = UIColor.blue
    /// The radius of the circles drawn for each joint.
    @IBInspectable var jointRadius: CGFloat = 4
    /// The color of the circles drawn for each joint.
    @IBInspectable var jointColor: UIColor = UIColor.red
    
    // get position of 2 new point
    //from 17 point to 14 point
    // middleShoulder of leftShoulder to rightSholder
    // centerBody of leftShoulder to rightSholder and leftHip to rightHip
    var middlePos : CGPoint = .init()
    var middleHip : CGPoint = .init()
    var centerPos : CGPoint = .init()
    
    
    // MARK: - Rendering methods

    /// Returns an image showing the detected poses.
    ///
    /// - parameters:
    ///     - poses: An array of detected poses.
    ///     - frame: The image used to detect the poses and used as the background for the returned image.
    // mang de luu lai vi tri 2 doan thang
    var arrOfLeftElbow: [CGPoint] = []
    var arrOfLeftKnee: [CGPoint] = []
    var arrOfRightElbow: [CGPoint] = []
    var arrOfRightKnee: [CGPoint] = []
    // arr for save the required position (x,y)
    var arrOfX:[CGFloat] = []
    var arrOfY:[CGFloat] = []
    
    
    
    
    var le:Int = 0 // left elbow
    var lk:Int = 0 // left knee
    var re:Int = 0 // right elbow
    var rk:Int = 0 // right elbow
    
    // calculate the length between 2 points
    func dotToDot(first : CGPoint, second :CGPoint ) -> Float{
        var kq:CGFloat
        kq = sqrt((first.x - second.x) * (first.x - second.x) + (first.y - second.y) * (first.y - second.y))
        return Float(kq)
    }
    // calculate the angle between two lines
    func angled(a: Float , b: Float , c: Float ) -> Int {
        var agl = acos(((a*a)+(c*c)-(b*b))/((2*(a)*(c))))
        agl = (agl/Float.pi)*180
        if !agl.isNaN {
            return Int(agl)
        }else{
            return 1
        }
        
    }
    //calculate angle in triangle 
    func countA(first : CGPoint, second :CGPoint,third :CGPoint) -> Int{
        var a,b,c:Float
        a = dotToDot(first: third, second: second)
        b = dotToDot(first: third, second: first)
        c = dotToDot(first: second, second: first)
        var kq:Int
        kq = angled(a: a, b: b, c: c)
        return kq
    }
    
    func show(poses: [Pose], on frame: CGImage) {
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,
                                               format: dstImageFormat)

        let dstImage = renderer.image { rendererContext in
            // Draw the current frame as the background for the new image.
            draw(image: frame, in: rendererContext.cgContext)
            
            

            for pose in poses {
                // Draw the segment lines.
                
                for segment in PoseImageView.jointSegments {
                    let jointA = pose[segment.jointA]
                    let jointB = pose[segment.jointB]
                    
                    
                    
                    guard jointA.isValid, jointB.isValid else {
                        continue
                    }
                    
                    
                    // for leftElbow
                    if jointA.name.name == "leftShoulder" && jointB.name.name == "leftElbow" {
                        
                        arrOfLeftElbow.append(jointA.position)//a
                        arrOfLeftElbow.append(jointB.position)//b
                    }
                    if jointA.name.name == "leftElbow" && jointB.name.name == "leftWrist" {
                        
                        arrOfLeftElbow.append(jointB.position)//c
                    }
                    
                    
                    // for leftKnee
                    if jointA.name.name == "leftHip" && jointB.name.name == "leftKnee" {
                        
                        arrOfLeftKnee.append(jointA.position)//a
                        arrOfLeftKnee.append(jointB.position)//b
                    }
                    if jointA.name.name == "leftKnee" && jointB.name.name == "leftAnkle" {
                        
                        arrOfLeftKnee.append(jointB.position)//c
                    }
                    
                    
                    // for rightElbow
                    if jointA.name.name == "rightShoulder" && jointB.name.name == "rightElbow" {
                        
                        arrOfRightElbow.append(jointA.position)//a
                        arrOfRightElbow.append(jointB.position)//b
                    }
                    if jointA.name.name == "rightElbow" && jointB.name.name == "rightWrist" {
                        
                        arrOfRightElbow.append(jointB.position)//c
                    }
                    
                    
                    
                    // for rightKnee
                    if jointA.name.name == "rightHip" && jointB.name.name == "rightKnee" {
                        
                        arrOfRightKnee.append(jointA.position)//a
                        arrOfRightKnee.append(jointB.position)//b
                    }
                    if jointA.name.name == "rightKnee" && jointB.name.name == "rightAnkle" {
                        
                        arrOfRightKnee.append(jointB.position)//c
                    }
                    
                    // draw from leftShoulder and rightShoulder to middle of Shoulder
                    if jointA.name == .leftShoulder && jointB.name == .rightShoulder{
                        middlePos.x = (jointB.position.x + jointA.position.x) / 2
                        middlePos.y = ((jointB.position.y + jointA.position.y) / 2) - 10
                        // new func of draw
                        drawLineNew(from: jointA.position, to: jointB.position, in: rendererContext.cgContext)
                        
                        
                    }
                    // draw from leftHip and rightHip to center point , from center point to middle of Shoulder
                    else if jointA.name == .leftHip && jointB.name == .rightHip{
                        middleHip.x = (jointB.position.x + jointA.position.x) / 2
                        middleHip.y = ((jointB.position.y + jointA.position.y) / 2)
                        // count center point
                        centerPos.x = (middleHip.x + middlePos.x) / 2
                        centerPos.y = ((middleHip.y + middlePos.y + 10) / 2)
                        drawLineCen(from: jointA.position, to: jointB.position, in: rendererContext.cgContext)
                        myDraw(circle: middlePos, in: rendererContext.cgContext)
                        myDraw(circle: centerPos, in: rendererContext.cgContext)
                    }
                    // draw the others
                    else{
                        drawLine(from: jointA,
                                 to: jointB,
                                 in: rendererContext.cgContext)
                        
                    }
                    
                    
                    
                }
                //1 LElbow
                le = 0
                if arrOfLeftElbow.count > 2{
                    le = countA(first: arrOfLeftElbow[0], second: arrOfLeftElbow[1], third: arrOfLeftElbow[2])
                    //print(gt)
                    arrOfLeftElbow.removeAll()
                }
                //2 LKnee
                lk = 0
                if arrOfLeftKnee.count > 2{
                    lk = countA(first: arrOfLeftKnee[0], second: arrOfLeftKnee[1], third: arrOfLeftKnee[2])
                    //print(gt)
                    arrOfLeftKnee.removeAll()
                }
                //3 RElbow
                re = 0
                if arrOfRightElbow.count > 2{
                    re = countA(first: arrOfRightElbow[0], second: arrOfRightElbow[1], third: arrOfRightElbow[2])
                    //print(gt)
                    arrOfRightElbow.removeAll()
                }
                //4 RKnee
                rk = 0
                if arrOfRightKnee.count > 2{
                    rk = countA(first: arrOfRightKnee[0], second: arrOfRightKnee[1], third: arrOfRightKnee[2])
                    //print(gt)
                    arrOfRightKnee.removeAll()
                }
                

                // Draw the joints as circles above the segment lines.
                for joint in pose.joints.values.filter({ $0.isValid }) {
                    
                    draw(circle: joint, in: rendererContext.cgContext,le : le,lk : lk,re : re,rk : rk)
                    arrOfX.append(joint.position.x)
                    arrOfY.append(joint.position.y)
                }
                arrOfX.sort()
                arrOfY.sort()
                //tao 4 diem cua hinh chu nhat ABCD
                //A
                if (!arrOfX.isEmpty)
                {
                    var A = CGPoint(x: 0, y: 0)
                    A.x = arrOfX.first! - CGFloat(20)
                    
                    A.y = arrOfY.last! + CGFloat(20)
                    //B
                    var B = CGPoint(x: 0, y: 0)
                    B.x = arrOfX.last! + CGFloat(20)
                    B.y = arrOfY.last! + CGFloat(20)
                    //C
                    var C = CGPoint(x: 0, y: 0)
                    C.x = arrOfX.last! + CGFloat(20)
                    C.y = arrOfY.first! - CGFloat(20)
                    //D
                    var D = CGPoint(x: 0, y: 0)
                    D.x = arrOfX.first! - CGFloat(20)
                    D.y = arrOfY.first! - CGFloat(20)
                    
                    // ve hinh chu nhat nay ra
                    
                    drawHC(a: A, b: B, c: C, d: D, in: rendererContext.cgContext)
                }
                
                
                
                //xoa mang lam lai
                arrOfY.removeAll()
                arrOfX.removeAll()
            }
        }

        image = dstImage
        
        
    }
    
    
    /// Vertically flips and draws the given image.
    ///
    /// - parameters:
    ///     - image: The image to draw onto the context (vertically flipped).
    ///     - cgContext: The rendering context.
    func draw(image: CGImage, in cgContext: CGContext) {
        cgContext.saveGState()
        // The given image is assumed to be upside down; therefore, the context
        // is flipped before rendering the image.
        cgContext.scaleBy(x: 1.0, y: -1.0)
        // Render the image, adjusting for the scale transformation performed above.
        let drawingRect = CGRect(x: 0, y: -image.height, width: image.width, height: image.height)
        cgContext.draw(image, in: drawingRect)
        cgContext.restoreGState()
    }

    /// Draws a line between two joints.
    ///
    /// - parameters:
    ///     - parentJoint: A valid joint whose position is used as the start position of the line.
    ///     - childJoint: A valid joint whose position is used as the end of the line.
    ///     - cgContext: The rendering context.
    func drawLine(from parentJoint: Joint,
                  to childJoint: Joint,
                  in cgContext: CGContext) {
        
        cgContext.setStrokeColor(segmentColor.cgColor)
        cgContext.setLineWidth(segmentLineWidth)
        cgContext.move(to: parentJoint.position)
        cgContext.addLine(to: childJoint.position)
        cgContext.strokePath()
      
        
    }
    // test my draw middle of shoulder
    func drawLineNew(from parentJoint: CGPoint,
                  to childJoint: CGPoint,
                  in cgContext: CGContext) {
        
        cgContext.setStrokeColor(segmentColor.cgColor)
        cgContext.setLineWidth(segmentLineWidth)
        
        
        // draw new line form leftShoulder to rightShoulder
        
        
        
        cgContext.move(to: parentJoint)
        cgContext.addLine(to: middlePos)
        cgContext.strokePath()
        cgContext.move(to: middlePos)
        cgContext.addLine(to: childJoint)
        cgContext.strokePath()
        
      
            
        
        
    }
    
    // draw center of 4 point
    func drawLineCen(from parentJoint: CGPoint,
                  to childJoint: CGPoint,
                  in cgContext: CGContext) {
        
        cgContext.setStrokeColor(segmentColor.cgColor)
        cgContext.setLineWidth(segmentLineWidth)
        
        
        // draw new line form leftShoulder to rightShoulder
        
        
        
        cgContext.move(to: parentJoint)
        cgContext.addLine(to: centerPos)
        cgContext.strokePath()
        cgContext.move(to: centerPos)
        cgContext.addLine(to: childJoint)
        cgContext.strokePath()
        
        // draw circle point
        
        
        
        cgContext.move(to: centerPos)
        cgContext.addLine(to: middlePos)
        cgContext.strokePath()
      
            
        
        
    }

    /// Draw a circle in the location of the given joint.
    ///
    /// - parameters:
    ///     - circle: A valid joint whose position is used as the circle's center.
    ///     - cgContext: The rendering context.
    private func draw(circle joint: Joint, in cgContext: CGContext, le : Int,lk : Int,re : Int,rk : Int) {
        
        
        drawAngled(joint: joint, in: cgContext, name: "leftElbow", gt: le)//1
        drawAngled(joint: joint, in: cgContext, name: "leftKnee", gt: lk)//2
        drawAngled(joint: joint, in: cgContext, name: "rightElbow", gt: re)//3
        drawAngled(joint: joint, in: cgContext, name: "rightKnee", gt: rk)//4
        
        cgContext.setFillColor(jointColor.cgColor)
        
        let rectangle = CGRect(x: joint.position.x - jointRadius, y: joint.position.y - jointRadius,
                               width: jointRadius * 2, height: jointRadius * 2)
        cgContext.addEllipse(in: rectangle)
        cgContext.drawPath(using: .fill)
        
    }
    // my cirrcle
    private func myDraw(circle joint: CGPoint, in cgContext: CGContext) {

        cgContext.setFillColor(jointColor.cgColor)
        
        let rectangle = CGRect(x: joint.x - jointRadius, y: joint.y - jointRadius,
                               width: jointRadius * 2, height: jointRadius * 2)
        cgContext.addEllipse(in: rectangle)
        cgContext.drawPath(using: .fill)
        
    }
    
    func drawAngled(joint: Joint,in cgContext : CGContext, name: String, gt: Int){
        UIGraphicsPushContext(cgContext)
        let font = UIFont.systemFont(ofSize: 15)
        //let string = NSAttributedString(string: joint.name.name, attributes: [NSAttributedString.Key.font: font])//ten bo phan
        if joint.name.name == name && gt != 0 {
            let string = NSAttributedString(string: String(gt) , attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.green ])// goc do
            
            string.draw(at: CGPoint(x: joint.position.x
                                    , y: joint.position.y))
            UIGraphicsPopContext()
            
        }
    }
    func drawHC(a:CGPoint ,b:CGPoint ,c:CGPoint ,d:CGPoint, in cgContext:CGContext){
        cgContext.setStrokeColor(UIColor.white.cgColor)
        cgContext.setLineWidth(segmentLineWidth)
        //ab
        cgContext.move(to: a)
        cgContext.addLine(to: CGPoint(x: a.x + 30, y: a.y))
        cgContext.move(to: a)
        cgContext.addLine(to: CGPoint(x: a.x, y: a.y - 30))
        
        //bc
        cgContext.move(to: b)
        cgContext.addLine(to: CGPoint(x: b.x - 30, y: b.y))
        cgContext.move(to: b)
        cgContext.addLine(to: CGPoint(x: b.x, y: b.y - 30))
        //cd
        cgContext.move(to: c)
        cgContext.addLine(to: CGPoint(x: c.x - 30, y: c.y))
        cgContext.move(to: c)
        cgContext.addLine(to: CGPoint(x: c.x, y: c.y + 30))
        //da
        cgContext.move(to: d)
        cgContext.addLine(to: CGPoint(x: d.x + 30, y: d.y))
        cgContext.move(to: d)
        cgContext.addLine(to: CGPoint(x: d.x, y: d.y + 30))
        
        cgContext.strokePath()
    }
    
    
}
