//
//  RotaryWheel.m
//  rotarywheelproject
//
//  Created by Patrick Cooke on 7/16/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

#import "RotaryWheel.h"
#import <QuartzCore/QuartzCore.h>

@interface RotaryWheel()

- (void)drawWheel;
- (float) calculateDistanceFromCenter:(CGPoint)point;
- (void) buildSectorsEven;
- (void) buildSectorsOdd;

@end

static float deltaAngle;
//static float minAlphavalue = 0.6;
//static float maxAlphavalue = 1.0;
//NSArray *colors = @[@"blueColor", @"redColor", @"greenColor", @"purpleColor"];


@implementation RotaryWheel

@synthesize delegate, container, numberOfSections, startTransform, sectors, currentSector;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber {
    if ((self = [super initWithFrame:frame])) {
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
        [self drawWheel];
        //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(rotate) userInfo:nil repeats:YES];
    }
    return self;
}

- (void) drawWheel {
    container = [[UIView alloc] initWithFrame:self.frame];
    CGFloat angleSize = 2*M_PI/numberOfSections;
//    NSArray *wheelColors = [NSArray arrayWithObjects:@"blueColor", @"redColor", @"greenColor", @"purpleColor",nil];
    self.currentSector = 0;
    for (int i = 0; i < numberOfSections; i++) {
        // 4
        UIBezierPath *shape = [UIBezierPath bezierPathWithArcCenter:CGPointMake(container.center.x, container.center.y) radius:100 startAngle:10 endAngle:45 clockwise:true];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = shape.CGPath;
        switch (i) {
            case 0:
                shapeLayer.fillColor = [UIColor blueColor].CGColor;
                break;
            case 1:
                shapeLayer.fillColor = [UIColor greenColor].CGColor;
                break;
            case 2:
                shapeLayer.fillColor = [UIColor redColor].CGColor;
                break;
            case 3:
                shapeLayer.fillColor = [UIColor purpleColor].CGColor;
                break;
            default:
                shapeLayer.fillColor = [UIColor clearColor].CGColor;
                break;
        }
        shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        shapeLayer.lineWidth = 2;
        
        [container.layer addSublayer:shapeLayer];
        
//        CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);
//        CGFloat radius = center.x - 10.f;
//        
//        
//        UIBezierPath *portionPath = [UIBezierPath bezierPath];
//        [portionPath moveToPoint:center];
//        [portionPath addArcWithCenter:center radius:radius startAngle:0.f endAngle:angleSize clockwise:YES];
//        [portionPath closePath];
//        
//        [[UIColor greenColor] setFill];
//        [portionPath fill];
//        
//        UIBezierPath *portionPath1 = [UIBezierPath bezierPath];
//        [portionPath1 moveToPoint:center];
//        [portionPath1 addArcWithCenter:center radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
//        [portionPath1 closePath];
//        
//        [[UIColor blueColor] setFill];
//        [portionPath1 fill];
//        
//        
//        [container.layer addSublayer:portionPath];
//        [container.layer addSublayer:portionPath1];
//        UIView *mm = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 250)];
//        mm.clipsToBounds = true;
//        mm.backgroundColor = [UIColor redColor];
//        mm.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
//        mm.layer.position = CGPointMake(container.bounds.size.width/2.0,
//                                        container.bounds.size.height/2.0);
//        mm.transform = CGAffineTransformMakeRotation(angleSize * i);
//        mm.tag=i;
//        
//        [container addSubview:mm];
        
        UILabel *im = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        im.backgroundColor = [UIColor redColor];
        im.text = [NSString stringWithFormat:@"%i", i];
        im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        // 5
        im.layer.position = CGPointMake(container.bounds.size.width/2.0,
                                        container.bounds.size.height/2.0);
        im.transform = CGAffineTransformMakeRotation(angleSize * i);
        im.tag = i;
        
//         6
        [container addSubview:im];
    }
    // 7
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    // 8 - initialize sectors
    sectors = [NSMutableArray arrayWithCapacity:numberOfSections];
    if (numberOfSections % 2 == 0) {
        [self buildSectorsEven];
    } else {
        [self buildSectorsOdd];
    }
    // 9
    [self.delegate wheelDidChangeValue:[NSString stringWithFormat:@"value is %i", self.currentSector]];
}

- (void) rotate {
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -0.78);
    container.transform = t;
}

- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    // this cancels tap if too close to center
    float dist = [self calculateDistanceFromCenter:touchPoint];
    if (dist < 40 || dist > 100) {
//        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    float dx = touchPoint.x - container.center.x;
    float dy = touchPoint.y - container.center.y;
    deltaAngle = atan2f(dy, dx);
    startTransform = container.transform;
    return YES;
    
}

- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pt = [touch locationInView:self];
    float dx = pt.x - container.center.x;
    float dy = pt.y - container.center.y;
    float ang = atan2f(dy, dx);
    float angleDifference = deltaAngle - ang;
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    // 1 - Get current container rotation in radians
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    // 2 - Initialize new value
    CGFloat newVal = 0.0;
    // 3 - Iterate through all the sectors
    for (Sector *s in sectors) {
        // 4 - Check for anomaly (occurs with even number of sectors)
        if (s.minValue > 0 && s.maxValue < 0) {
            if (s.maxValue > radians || s.minValue < radians) {
                // 5 - Find the quadrant (positive or negative)
                if (radians > 0) {
                    newVal = radians - M_PI;
                } else {
                    newVal = M_PI + radians;
                }
                currentSector = s.sector;
            }
        }
        // 6 - All non-anomalous cases
        else if (radians > s.minValue && radians < s.maxValue) {
            newVal = radians - s.midValue;
            currentSector = s.sector;
        }
        [self.delegate wheelDidChangeValue:[NSString stringWithFormat:@"value is %i", self.currentSector]];
    }
    // 7 - Set up animation for final rotation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -newVal);
    container.transform = t;
    [UIView commitAnimations];
}

- (float) calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}

- (void) buildSectorsOdd {
    // 1 - Define sector length
    CGFloat fanWidth = M_PI*2/numberOfSections;
    // 2 - Set initial midpoint
    CGFloat mid = 0;
    // 3 - Iterate through all sectors
    for (int i = 0; i < numberOfSections; i++) {
        Sector *sector = [[Sector alloc] init];
        // 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        mid -= fanWidth;
        if (sector.minValue < - M_PI) {
            mid = -mid;
            mid -= fanWidth;
        }
        // 5 - Add sector to array
        [sectors addObject:sector];
//        NSLog(@"cl is %@", sector);
    }
}

- (void) buildSectorsEven {
    // 1 - Define sector length
    CGFloat fanWidth = M_PI*2/numberOfSections;
    // 2 - Set initial midpoint
    CGFloat mid = 0;
    // 3 - Iterate through all sectors
    for (int i = 0; i < numberOfSections; i++) {
        Sector *sector = [[Sector alloc] init];
        // 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        if (sector.maxValue-fanWidth < - M_PI) {
            mid = M_PI;
            sector.midValue = mid;
            sector.minValue = fabsf(sector.maxValue);
            
        }
        mid -= fanWidth;
//        NSLog(@"cl is %@", sector);
        // 5 - Add sector to array
        [sectors addObject:sector];
    }
}

    
    



@end
