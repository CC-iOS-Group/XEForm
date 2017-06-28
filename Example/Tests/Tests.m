//
//  XEFormTests.m
//  XEFormTests
//
//  Created by xenobladeX on 06/22/2017.
//  Copyright (c) 2017 xenobladeX. All rights reserved.
//

// https://github.com/kiwi-bdd/Kiwi

#import "TestForm.h"

SPEC_BEGIN(InitialTests)

describe(@"XEForm tests", ^{

  context(@"Test Form Object", ^{

      it(@"test properties", ^{
          TestForm *form = [[TestForm alloc] init];
          form.rows = @[
                        @"games",
                        @"age",
                        ];;
//          NSArray *objects = [XEFormRowObject objectsWithForm:form controller:nil];
          [[@(1) should] equal:@(1)];
      });
  });

//  context(@"will pass", ^{
//    
//      it(@"can do maths", ^{
//          
//          [[@1 should] beLessThan:@23];
//      });
//
//      it(@"can read", ^{
//          [[@"team" shouldNot] containString:@"I"];
//      });  
//  });
  
});

SPEC_END

