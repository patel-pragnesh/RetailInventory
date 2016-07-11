//
//  TagData.swift
//  RetailInventorySwift
//
//  Created by Sak, Andrey2 on 7/11/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class TagData: EntityMethods<Tag> {
    
    init() {
        let tags = DataManager.fetchAllTag()
        super.init(array: tags)
    }
    
    static func addTag(active: Bool?, id: Int!, itemTagDesc: String?, hidden: Bool?) -> Tag {
        return DataManager.addTag(id, active: active, hidden: hidden, itemTagDesc: itemTagDesc)
    }
    
    static func addTagsFromResponse(tagsResponse: [TagResponse]) {
        let localTags = DataManager.fetchAllTag()
        
        for tag in tagsResponse {
            var isConsist = false
            for locTag in localTags {
                if locTag.id == tag.id {
                    updateTag(locTag, fromResponse: tag)
                    isConsist = true
                    break
                }
            }
            if !isConsist {
                addTag(tag.active, id: tag.id, itemTagDesc: tag.itemTagDesc, hidden: tag.hidden)
            }            
        }
    }
    
    static func updateTag(locTag: Tag, fromResponse newTag: TagResponse) {
        locTag.active = newTag.active
        locTag.hidden = newTag.hidden
        locTag.itemTagDesc = newTag.itemTagDesc
    }
}