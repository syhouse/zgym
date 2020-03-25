//
//  UIVIew+Position.swift
//  ZGYM
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

extension UIView{
    var sl_x : CGFloat{
        set{
            self.frame.origin.x = newValue
        }
        get{
            return self.frame.origin.x
        }
    }
    
    var sl_y : CGFloat{
        set{
            self.frame.origin.y = newValue
        }
        get{
            return self.frame.origin.y
        }
    }
    
    var sl_height : CGFloat{
        set{
            self.frame.size.height = newValue
        }
        get{
            return self.frame.size.height
        }
    }
    
    var sl_width : CGFloat{
        set{
            self.frame.size.width = newValue
        }
        get{
            return self.frame.size.width
        }
    }
    
    var sl_size : CGSize{
        set{
            self.frame.size = newValue
        }
        get{
            return self.frame.size
        }
    }
    var sl_origin : CGPoint{
        set{
            self.frame.origin = newValue
        }
        get{
            return self.frame.origin
        }
    }
    var sl_centerX : CGFloat{
        set{
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get{
            return self.center.x
        }
    }
    var sl_centerY : CGFloat{
        set{
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get{
            return self.center.y
        }
    }
    
    var sl_left : CGFloat{
        set{
            self.sl_x = newValue
        }
        get{
            return self.sl_x
        }
    }
    var sl_top : CGFloat{
        set{
            self.sl_y = newValue
        }
        get{
            return self.sl_y
        }
    }
    var sl_right : CGFloat{
        set{
            self.sl_x = newValue - self.sl_width
        }
        get{
            return self.sl_x + self.sl_width
        }
    }
    var sl_bottom : CGFloat{
        set{
            self.sl_y = newValue - self.sl_height
        }
        get{
            return self.sl_y + self.sl_height
        }
    }
    
}
