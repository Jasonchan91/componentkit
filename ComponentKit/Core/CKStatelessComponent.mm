/*
 *  Copyright (c) 2014-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the BSD-style license found in the
 *  LICENSE file in the root directory of this source tree. An additional grant
 *  of patent rights can be found in the PATENTS file in the same directory.
 *
 */

#import "CKStatelessComponent.h"
#import "CKStatelessComponentContext.h"

@implementation CKStatelessComponent

+ (instancetype)newWithView:(const CKComponentViewConfiguration &)view component:(CKComponent *)component identifier:(NSString *)identifier
{
  const auto c = [super newWithView:view component:component];

  if (c) {
    c->_identifier = [identifier copy];
  }

  return c;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ (%@)", _identifier, NSStringFromClass([self class])];
}

@end

CKComponent *CKCreateStatelessComponent(NS_RELEASES_ARGUMENT CKComponent *component, const char *debugIdentifier) NS_RETURNS_RETAINED
{
#if CK_ASSERTIONS_ENABLED
  if (component == nil) {
    return nil;
  }
  return
  [CKStatelessComponent
   newWithView:{}
   component:component
   identifier:[NSString stringWithCString:debugIdentifier encoding:NSUTF8StringEncoding]];
#else
  if (component != nil && [CKComponentContext<CKStatelessComponentContext>::get() shouldAllocateComponent]) {
    return [CKStatelessComponent
     newWithView:{}
     component:component
     identifier:[NSString stringWithCString:debugIdentifier encoding:NSUTF8StringEncoding]];
  } else {
    return component;
  }
#endif
}
