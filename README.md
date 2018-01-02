# LinkedScrollView

![](https://github.com/heron-newland/LinkedScroll/blob/master/img/icon.png)
## 中文教程
LinkedScrollView是一款处理上下联动的使用框架,适配iPhoneX, 并且支持屏幕旋转. 后期会不断增加新的功能.欢迎各位使用者提出建议和意见.
### 基本类介绍
*	HLLScrollTitleView.swift 标题view

*	HLLScrollContentView.swift	内容view

*	HLLScrollViewControllerDelegate.swift 处理标题和内容联动的代理

*	HLLScrollViewDataSource.swift	控件的数据源, 我们必须自己实现数据源方法

*	HLLScrollViewDelegate.swift	控件的代理, 选择实现来获取控件信息

*	HLLScrollView.swift	继承titleView 和 contentView的合成view, 使用此控件的时候主要使用它

*	HLLScrollViewController.swift 集成scrollView的控制器, 我们可以集成自这个类, 实现简单的上下联动的控制器

* HLLTitleView: 自定义titleView中的没有标题的时候使用此类, 继承他然后自定义里面的控件即可

### 集成方法
要求: 
>iOS 9.0或以上

>xCode 9.0或以上

>swift 4.0 或以上


*	 手动集成
 
		将LinkedScrollView文件夹手动拖入工程即可
	
*	 cocoaPods集成
	
			platform :ios, '9.0'
			
			target 'testMyPods' do
		
			use_frameworks!
			
			pod 'LinkedScroll'
			
			end


### 使用方法
*	 方式一:继承自`HLLScrollViewController`, 实现数据源方法即可, 使用方式可UITableViewController一致, 具体代码如下:

		import UIKit
		
		class HomeViewController: HLLScrollViewController {
	
	    override func viewDidLoad() {
	        super.viewDidLoad()
	    }
	
	    
	    //MARK: - 数据源方法***************************
	    
	    /// 标题数据源
	    ///
	    /// - Parameter scrollView:
	    /// - Returns: 字符串数组, 用来显示标题
		  	 override func scrollTitles(for scrollView: HLLScrollView?) -> [String] {
		        return ["新闻房产", "体育", "房产财经", "房产", "动漫房产", "动漫","新闻房产", "体育",]
		    }
	    
		   /// 内容数据源
		   ///
		   /// - Parameter scrollView:
		   /// - Returns: 控制器数组, 用于显示内容
			   override func scrollContentViewControllers(for scrollView: HLLScrollView?) -> [UIViewController] {
		        var controllers = [UIViewController]()
		    //这里简单用for循环创建控制器, 具体控制器根据实际情况创建
		        for _ in 0 ..< 8 {
		            controllers.append(NewsViewController())
		        }
		        return controllers
		    }
	    
	    /// 内容控制器的父控制器, 用来添加自控制器,可以不实现, 默认为nil
	    override func scrollContentParentViewController(for scrollView: HLLScrollView?) -> UIViewController? {
	        return self;
	    }
	   
	    //MARK: - 代理方法, 根据需要选择是否实现, 所有的方法都在HLLScrollViewDelegate里面***************************
	    override func titleScrollViewDidScroll(titleScrollView: UIScrollView) {
	        print(titleScrollView.contentOffset.x)
	    }
	    
	    override func contentScrollViewDidScroll(contentScrollView: UIScrollView) {
	        print(contentScrollView.contentOffset.x)
	    }
	
		}


* 	方式二:初始化一个 `HLLScrollView`(继承自UIView),添加到控制的view中即可, 代码 如下:

		/// 懒加载一个HLLScrollView, 并设置相关属性
		private lazy var scrollView: HLLScrollView = {
	        let sView = HLLScrollView()
	        
	        //数据源代理
        sView.dataSource = self
        sView.delegate = self
        
      	 return sView
	    }()
	
	
	    override func viewDidLoad() {
	        super.viewDidLoad()
	        //添加HLLScrollView对象到控制器view中
	        view.addSubview(scrollView)
	    }
	
	    override func viewDidLayoutSubviews() {
	        super.viewDidLayoutSubviews()
         //在此设置HLLScrollView对象的frame, navi, tabbar, statusBar,的高度获取方法见extension文件
         scrollView.frame = CGRect(x: 0, y: self.navigateBarHeight() + UIApplication.getStatusBarHeight(), width: view.bounds.width, height: view.bounds.height - self.navigateBarHeight() - self.tabBarHeight() - UIApplication.getStatusBarHeight())
    	}
    	
    	//然后实现数据源方法, 实现方式见方式一
    	
    	//根据需要实现代理方法, 实现方式见方式一
    	
### 使用技巧
通过改变属性值可以自定义自己想要的样式, 具体属性如下:
*	HLLScrollView属性


* HLLScrollTitleView属性
		
>*	isIndicatorLineHidden: 是否文字下方的指示线是否隐藏, 默认为false(不隐藏)

>>![无指示线](https://github.com/heron-newland/LinkedScroll/blob/master/img/noIndicator.png)

>>![有线](https://github.com/heron-newland/LinkedScroll/blob/master/img/hasIndicator.png)

>*	highlightTextColor: 文字高亮颜色, 指示线的颜色默认和高亮文字颜色一致也可以通过scrollTitleView.lineView.backgroundColor属性自行修改

>*	normalTextColor: 文字普通颜色

>>![](https://github.com/heron-newland/LinkedScroll/blob/master/img/changeColor.png)

>*	titleView:整个标题视图, 是` [HLLTitleView]`类型

>*	titleViewHeight: 标题视图的高度

>>![](https://github.com/heron-newland/LinkedScroll/blob/master/img/changeH.png)

>*	lineHeight: 指示线的高度

>>![](https://github.com/heron-newland/LinkedScroll/blob/master/img/lineH.png)

>*	textScaleRate:当前选中label放大的增量, 如果设为0.0则不缩放, 默认值为0.0, 不要设置太大, 值太大由于高度不够文字会显示不全

>>![](https://github.com/heron-newland/LinkedScroll/blob/master/img/textScale.png)

>*	textFont:title字体大小, titleLabel的宽度会随着字体的变化而变化, 但是高度不会变化, 通过`titleViewHeight`属性设置适当的高度

>>![](https://github.com/heron-newland/LinkedScroll/blob/master/img/textFont.png)

> *	lineView:指示线, 可以自定义指示线, 或者通过改变其属性定义自己的效果

> *	rightView: titleView右边的视图, 比如可以定义一个按钮, 点击查看所有条目, 如下图中的加号

>>![](https://github.com/heron-newland/LinkedScroll/blob/master/img/right.png)

> *	isMarkHiddenByTap: title的标记是否在点击之后消失, 如果为true那么标记视图在点击后会消失, 下图中红点就是标记

>>![](https://github.com/heron-newland/LinkedScroll/blob/master/img/mark.png)
 
> *	margin: 每title之间的间距


* HLLScrollContentView属性

>*	isPanToSwitchEnable: 是否允许左右滑动内容来切换标题标签, 默认为true

*	通过属性组合得到的效果

>让指示线的高度等于titleView的高度, 具体组合属性设置ruxia:

		//备注: sView就是HLLScrollView对象
        sView.titleViewHeight = 44
        sView.scrollTitleView.lineView.layer.cornerRadius = 16
        sView.scrollTitleView.lineHeight = 44
        sView.scrollTitleView.lineView.backgroundColor = UIColor.blue

>>![](https://github.com/heron-newland/LinkedScroll/blob/master/img/effect1.png)


*	自定义titleView的方法(如果不设置自定义title, title里面只有一个label), 自定义的方式如下:

>   	 func scrollTitles(for scrollView: HLLScrollView?) -> [String] {
	        let titles = ["新闻","大家都在看", "直播", "体育", "财经", "房产", "动漫", "猜你感兴趣","大家都在看", "直播"]
 			 var ts = [TitleView]()
        //根据标题初始化titleView中的每一个title视图, 下面简单的使用for循环创建,可以根据实际需求创建
        //TitleView 是每个title的自定义视图, 继承自HLLTitleView
        for (index, _) in titles.enumerated() {
            let tView = TitleView(frame: CGRect(x: 0, y: 0, width: 90, height: 40))
            tView.isRightHidden = index % 2 == 0
            ts.append(tView)
        }
      	  scrollView?.scrollTitleView.titleView = ts
      	  return titles
    	}

*	自定义rightView的方式如下:
 
>	      let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
	     btn.setImage(#imageLiteral(resourceName: "增加-4"), for: .normal)
	     btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
	     //sView是HLLScrollView的实例
	     sView.scrollTitleView.rightView = btn

###  联系方式

*	email: objc_china@163.com