//
//  ModelRepository.h
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 03/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#ifndef ModelRepository_h
#define ModelRepository_h

#import <Foundation/Foundation.h>

@interface ModelRepository : NSObject

-(id) init: (NSString*) modelName className: (NSString*) className;
-(id) modelWithId: (int) id;

@end

#endif /* ModelRepository_h */
