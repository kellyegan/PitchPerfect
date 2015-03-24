//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Kelly Egan on 3/23/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init( filePath: NSURL! ) {
        filePathUrl = filePath
        title = filePathUrl.lastPathComponent
    }
}
