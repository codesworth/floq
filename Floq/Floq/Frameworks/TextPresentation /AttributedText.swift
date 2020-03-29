//
//  AttributedText.swift
//  Codesworth
//
//  Created by Shadrach Mensah on 17/01/2020.
//  Copyright © 2020 Codesworth. All rights reserved.
//

import UIKit



public struct AttributedText{
    
    fileprivate static var __WHITESPACE = " "
    
    private let attibutedText:NSMutableAttributedString = NSMutableAttributedString()
    public private(set) var attributes:[NSAttributedString.Key:Any] = [:]
    private var string:String = ""
    public init(string:String) {
        self.string = string
    }
    
    public var attributedString:NSAttributedString{
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    public func attributed(_ string:String)->NSAttributedString{
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    public func height(of string:String? = nil, with width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let boundingBox = (string ?? self.string).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes:attributes, context: nil)
        return ceil(boundingBox.height)
    }
    
    public func width(of string:String? = nil, with height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = (string ?? self.string).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return ceil(boundingBox.width)
    }
    
    
}


extension AttributedText{
    
    
    public struct Ligatures{
        let value:Int
        
        static let yes = Ligatures(value: 1)
        static let no = Ligatures(value: 0)
        
        static func custom(_ val:Int)->Ligatures{
            return Ligatures(value: val)
        }
    }
    
    public struct TextEffect{
        let value:NSString
        static let letterpress = TextEffect(value: NSAttributedString.TextEffectStyle.letterpressStyle as NSString)
        private init(value:NSString){
            self.value = value
        }
    }
    
    public enum Attribute{

        
           case font(UIFont)
           case kern(CGFloat)
           case textColor(UIColor) // UIColor, default blackColor
           case backgroundColor(UIColor?)// UIColor, default nil: no background
           case ligature(Ligatures)// NSNumber containing integer, default 1: default ligatures, 0: no ligatures
           case strikethroughStyle(Int) // NSNumber containing integer, default 0: no strikethrough

           case underlineStyle(Int) // NSNumber containing integer, default 0: no underline
           case strokeColor(UIColor)// UIColor, default nil: same as foreground color

           case strokeWidth(CGFloat) // NSNumber containing floating point value, in percent of font point size, default 0: no stroke; positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
           case shadow(TextShadow) // NSShadow, default nil: no shadow

           case textEffect(TextEffect) // NSString, default nil: no text effect
           case attachment(NSTextAttachment) // NSTextAttachment, default nil

           case link(Link) // NSURL (preferred) or NSString

           case baselineOffset(CGFloat) // NSNumber containing floating point value, in points; offset from baseline, default 0

           case  underlineColor(UIColor) // UIColor, default nil: same as foreground color

           case strikethroughColor(UIColor) // UIColor, default nil: same as foreground color

           case obliqueness(CGFloat) // NSNumber containing floating point value; skew to be applied to glyphs, default 0: no skew

           case expansion(CGFloat) // NSNumber containing floating point value; log of expansion factor to be applied to glyphs, default 0: no expansion

           
           case writingDirection(WrtingDirection) // NSArray of NSNumbers representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.  The control characters can be obtained by masking NSWritingDirection and NSWritingDirectionFormatType values.  LRE: NSWritingDirectionLeftToRight|NSWritingDirectionEmbedding, RLE: NSWritingDirectionRightToLeft|NSWritingDirectionEmbedding, LRO: NSWritingDirectionLeftToRight|NSWritingDirectionOverride, RLO: NSWritingDirectionRightToLeft|NSWritingDirectionOverride,

           
           case verticalGlyphForm(GlyphForm) // An NSNumber containing an integer value.  0 means horizontal text.  1 indicates vertical text.  If not specified, it could follow higher-level vertical orientation settings.  Currently on iOS, it's always horizontal.  The behavior for any other value is undefined.
        
            case lineSpacing(CGFloat)

            case paragraphSpacing(CGFloat)

            case alignment(NSTextAlignment)

            case firstLineHeadIndent(CGFloat)

            case headIndent(CGFloat)

            case tailIndent(CGFloat)

            case lineBreakMode(NSLineBreakMode)

            case minimumLineHeight(CGFloat)

            case maximumLineHeight(CGFloat)

            case baseWritingDirection(NSWritingDirection)

            case lineHeightMultiple(CGFloat)

            case paragraphSpacingBefore(CGFloat)

            case hyphenationFactor(Float)

            @available(iOS 7.0, macCatalyst 13.0, *)
            case tabStops([NSTextTab])
            @available(iOS 7.0, macCatalyst 13.0, *)
            case defaultTabInterval(CGFloat)
            @available(iOS 9.0, macCatalyst 13.0, *)
            case allowsDefaultTighteningForTruncation(Bool)
       }
    
    public enum GlyphForm:Int {
        case horizontal = 0
        case vertical = 1
    }
}




extension AttributedText{
    mutating
    public func attributing(_ attribute:AttributedText.Attribute)->AttributedText{
        var attrs = self.attributes
        switch attribute{
        case .font(let font):
            attrs.updateValue(font, forKey: .font)
            break
        case .kern(let k):
            attrs.updateValue(k, forKey: .kern)
            break
        case .textColor(let c):
            attrs.updateValue(c, forKey: .foregroundColor)
            break
        case .obliqueness(let val):
            attrs.updateValue(NSNumber(value: Float(val)), forKey: .obliqueness)
            break
        case .backgroundColor(let color):
            attrs.updateValue(color ?? .clear, forKey: .backgroundColor)
            break
        case .expansion(let val):
            attrs.updateValue(NSNumber(value: Float(val)), forKey: .expansion)
            break
        case .baselineOffset(let val):
            attrs.updateValue(NSNumber(value: Float(val)), forKey: .baselineOffset)
            break
        case .ligature(let ligature):
            attrs.updateValue(NSNumber(value: ligature.value), forKey: .ligature)
            break
        case .strikethroughColor(let color):
            attrs.updateValue(color, forKey: .strikethroughColor)
            break
        case .strokeColor(let color):
            attrs.updateValue(color, forKey: .strokeColor)
            break
        case .underlineColor(let color):
            attrs.updateValue(color, forKey: .underlineColor)
            break
        case .strokeWidth(let val):
            attrs.updateValue(NSNumber(value: Float(val)), forKey: .ligature)
            break
        case .strikethroughStyle(let val):
            attrs.updateValue(NSNumber(value: val), forKey: .strikethroughStyle)
            break
        case .underlineStyle(let val):
            attrs.updateValue(NSNumber(value: val), forKey: .strikethroughStyle)
            break
        case .link(let link):
            attrs.updateValue(link.linkURL, forKey: .link)
            break
        case .shadow(let shadow):
            attrs.updateValue(shadow.getShadow, forKey: .shadow)
            break
        case .textEffect(let effect):
            attrs.updateValue(effect.value, forKey: .textEffect)
            break
        case .verticalGlyphForm(let glyph):
            attrs.updateValue(glyph.rawValue, forKey: .verticalGlyphForm)
            break
        case .writingDirection(let direction):
            attrs.updateValue(direction.attributableValues, forKey: .writingDirection)
            break
        case .attachment(let attachment):
            attrs.updateValue(attachment, forKey: .attachment)
            break
        case .lineSpacing(let spacing):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.lineSpacing = spacing
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = spacing
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .paragraphSpacing(let spacing):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.paragraphSpacing = spacing
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.paragraphSpacing = spacing
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .alignment(let alignment):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.alignment = alignment
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = alignment
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .firstLineHeadIndent(let indent):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.firstLineHeadIndent = indent
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.firstLineHeadIndent = indent
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .headIndent(let indent):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.headIndent = indent
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.headIndent = indent
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .tailIndent(let indent):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.tailIndent = indent
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.tailIndent = indent
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .lineBreakMode(let breakmode):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.lineBreakMode = breakmode
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineBreakMode = breakmode
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .minimumLineHeight(let height):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.minimumLineHeight = height
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.minimumLineHeight = height
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .maximumLineHeight(let height):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.maximumLineHeight = height
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.maximumLineHeight = height
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .baseWritingDirection(let direction):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.baseWritingDirection = direction
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.baseWritingDirection = direction
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .lineHeightMultiple(let multiple):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.lineHeightMultiple = multiple
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineHeightMultiple = multiple
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .paragraphSpacingBefore(let spacing):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.paragraphSpacingBefore = spacing
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.paragraphSpacingBefore = spacing
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .hyphenationFactor(let factor):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.hyphenationFactor = factor
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.hyphenationFactor = factor
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .tabStops(let stops):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.tabStops = stops
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.tabStops = stops
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .defaultTabInterval(let interval):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.defaultTabInterval = interval
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.defaultTabInterval = interval
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        case .allowsDefaultTighteningForTruncation(let allows):
            if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                paragraph.allowsDefaultTighteningForTruncation = allows
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }else{
                let paragraph = NSMutableParagraphStyle()
                paragraph.allowsDefaultTighteningForTruncation = allows
                attrs.updateValue(paragraph, forKey: .paragraphStyle)
            }
            break
        }
        self.attributes = attrs
        return self
    }
}

extension AttributedText{
    
    
    
    public struct TextShadow{
        private let shadow:NSShadow
        
        public static func dropShadow(offset:CGSize = CGSize(width: 0, height: 2), blur:CGFloat = 2, color:UIColor = .black, opacity:CGFloat = 0.6)->TextShadow{
            let shadow = NSShadow()
            shadow.shadowBlurRadius = blur
            shadow.shadowColor = color
            shadow.shadowOffset = offset
            return TextShadow(shadow:shadow)
        }
        
        public var getShadow:NSShadow{
            return shadow
        }
    }
}


extension AttributedText{
    
    public typealias Ranges = Array<Range<String.Index>>
    
    fileprivate var RangeOfString:Range<String.Index>{
        return string.startIndex..<string.startIndex
    }
    
    fileprivate func rangeSubString(_ sub:String)->Range<String.Index>?{
        return string.range(of: sub)
    }
    
    fileprivate func rangesofSubstring(_ sub:String)-> Ranges{
        var ranges:Ranges = []
        
        var mutableString = string
        while true{
            if let range = mutableString.range(of: sub){
                ranges.append(range)
                let replaceText = String(repeating: AttributedText.__WHITESPACE, count:sub.count)
                mutableString.replaceSubrange(range, with: replaceText)
                continue
            }
            break
        }
        
        return ranges
    }
    
    public func attributing(_ attibutes:[AttributedText.Attribute])->AttributedText{
        return AttributedText(string: "")
    }
}


extension AttributedText{
    
    public struct WrtingDirection{
        
        public enum Direction:Int{
            case leftToRightEmbedding = 0
            case rightToLeftEmbedding = 1
            case leftToRightOverride = 2
            case rightToLeftOverride = 3
        }
        let directions:[Direction]
        init(_ directions:[Direction]){
            self.directions = directions
        }
        public var attributableValues:[NSNumber]{
            return directions.compactMap{NSNumber(integerLiteral: $0.rawValue)}
        }
    }
}



extension AttributedText{
    
    public struct Link {
        let url:String
        
        public init(_ url:String){
            self.url = url
        }
        
        public var linkURL:Any{
            return NSURL(string: url) ?? url
        }
    }
}



extension String{
    
    public func addingAttribute(_ attribute:AttributedText.Attribute)->AttributedText{
        var attr = AttributedText(string: self)
        return attr.attributing(attribute)
    }
    
    public func attributing(_ attributes:[AttributedText.Attribute])->NSAttributedString{
        var attrs:[NSAttributedString.Key:Any] = [:]
        attributes.forEach{
            switch $0{
            case .font(let font):
                attrs.updateValue(font, forKey: .font)
                break
            case .kern(let k):
                attrs.updateValue(k, forKey: .kern)
                break
            case .textColor(let c):
                attrs.updateValue(c, forKey: .foregroundColor)
                break
            case .obliqueness(let val):
                attrs.updateValue(NSNumber(value: Float(val)), forKey: .obliqueness)
                break
            case .backgroundColor(let color):
                attrs.updateValue(color ?? .clear, forKey: .backgroundColor)
                break
            case .expansion(let val):
                attrs.updateValue(NSNumber(value: Float(val)), forKey: .expansion)
                break
            case .baselineOffset(let val):
                attrs.updateValue(NSNumber(value: Float(val)), forKey: .baselineOffset)
                break
            case .ligature(let ligature):
                attrs.updateValue(NSNumber(value: ligature.value), forKey: .ligature)
                break
            case .strikethroughColor(let color):
                attrs.updateValue(color, forKey: .strikethroughColor)
                break
            case .strokeColor(let color):
                attrs.updateValue(color, forKey: .strokeColor)
                break
            case .underlineColor(let color):
                attrs.updateValue(color, forKey: .underlineColor)
                break
            case .strokeWidth(let val):
                attrs.updateValue(NSNumber(value: Float(val)), forKey: .ligature)
                break
            case .strikethroughStyle(let val):
                attrs.updateValue(NSNumber(value: val), forKey: .strikethroughStyle)
                break
            case .underlineStyle(let val):
                attrs.updateValue(NSNumber(value: val), forKey: .strikethroughStyle)
                break
            case .link(let link):
                attrs.updateValue(link.linkURL, forKey: .link)
                break
            case .shadow(let shadow):
                attrs.updateValue(shadow.getShadow, forKey: .shadow)
                break
            case .textEffect(let effect):
                attrs.updateValue(effect.value, forKey: .textEffect)
                break
            case .verticalGlyphForm(let glyph):
                attrs.updateValue(glyph.rawValue, forKey: .verticalGlyphForm)
                break
            case .writingDirection(let direction):
                attrs.updateValue(direction.attributableValues, forKey: .writingDirection)
                break
            case .attachment(let attachment):
                attrs.updateValue(attachment, forKey: .attachment)
                break
            case .lineSpacing(let spacing):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.lineSpacing = spacing
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineSpacing = spacing
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .paragraphSpacing(let spacing):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.paragraphSpacing = spacing
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.paragraphSpacing = spacing
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .alignment(let alignment):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                   paragraph.alignment = alignment
                   attrs.updateValue(paragraph, forKey: .paragraphStyle)
               }else{
                   let paragraph = NSMutableParagraphStyle()
                   paragraph.alignment = alignment
                   attrs.updateValue(paragraph, forKey: .paragraphStyle)
               }
               break
            case .firstLineHeadIndent(let indent):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.firstLineHeadIndent = indent
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.firstLineHeadIndent = indent
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .headIndent(let indent):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.headIndent = indent
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.headIndent = indent
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .tailIndent(let indent):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.tailIndent = indent
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.tailIndent = indent
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .lineBreakMode(let breakmode):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.lineBreakMode = breakmode
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineBreakMode = breakmode
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .minimumLineHeight(let height):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.minimumLineHeight = height
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.minimumLineHeight = height
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .maximumLineHeight(let height):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.maximumLineHeight = height
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.maximumLineHeight = height
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .baseWritingDirection(let direction):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.baseWritingDirection = direction
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.baseWritingDirection = direction
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .lineHeightMultiple(let multiple):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.lineHeightMultiple = multiple
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineHeightMultiple = multiple
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .paragraphSpacingBefore(let spacing):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.paragraphSpacingBefore = spacing
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.paragraphSpacingBefore = spacing
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .hyphenationFactor(let factor):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.hyphenationFactor = factor
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.hyphenationFactor = factor
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .tabStops(let stops):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.tabStops = stops
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.tabStops = stops
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .defaultTabInterval(let interval):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.defaultTabInterval = interval
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.defaultTabInterval = interval
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            case .allowsDefaultTighteningForTruncation(let allows):
                if let paragraph = attrs[.paragraphStyle] as? NSMutableParagraphStyle{
                    paragraph.allowsDefaultTighteningForTruncation = allows
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }else{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.allowsDefaultTighteningForTruncation = allows
                    attrs.updateValue(paragraph, forKey: .paragraphStyle)
                }
                break
            }
        }
       return NSAttributedString(string: self, attributes: attrs)
    }
    
    
}


//func uniqueuing<Element:RawRepresentable>(lhs:Array<Element>, rhs:Array<Element>)->Array<Element>{
//    var newArray:Array<Element> = lhs
//    for attr in rhs {
//        if newArray.contains(where: { (raw) -> Bool in
//            return raw.rawValue == attr.rawValue
//        })
//    }
//}

