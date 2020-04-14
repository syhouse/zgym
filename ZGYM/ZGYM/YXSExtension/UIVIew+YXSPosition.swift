//
//  UIVIew+Position.swift
//  HNYMEducation
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

extension UIView{
    var yxs_x : CGFloat{
        set{
            self.frame.origin.x = newValue
        }
        get{
            return self.frame.origin.x
        }
    }
    
    var yxs_y : CGFloat{
        set{
            self.frame.origin.y = newValue
        }
        get{
            return self.frame.origin.y
        }
    }
    
    var yxs_height : CGFloat{
        set{
            self.frame.size.height = newValue
        }
        get{
            return self.frame.size.height
        }
    }
    
    var yxs_width : CGFloat{
        set{
            self.frame.size.width = newValue
        }
        get{
            return self.frame.size.width
        }
    }
    
    var yxs_size : CGSize{
        set{
            self.frame.size = newValue
        }
        get{
            return self.frame.size
        }
    }
    var yxs_origin : CGPoint{
        set{
            self.frame.origin = newValue
        }
        get{
            return self.frame.origin
        }
    }
    var yxs_centerX : CGFloat{
        set{
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get{
            return self.center.x
        }
    }
    var yxs_centerY : CGFloat{
        set{
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get{
            return self.center.y
        }
    }
    
    var yxs_left : CGFloat{
        set{
            self.yxs_x = newValue
        }
        get{
            return self.yxs_x
        }
    }
    var yxs_top : CGFloat{
        set{
            self.yxs_y = newValue
        }
        get{
            return self.yxs_y
        }
    }
    var yxs_right : CGFloat{
        set{
            self.yxs_x = newValue - self.yxs_width
        }
        get{
            return self.yxs_x + self.yxs_width
        }
    }
    var yxs_bottom : CGFloat{
        set{
            self.yxs_y = newValue - self.yxs_height
        }
        get{
            return self.yxs_y + self.yxs_height
        }
    }
    
}
