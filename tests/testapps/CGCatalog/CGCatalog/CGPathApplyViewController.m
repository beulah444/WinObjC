//******************************************************************************
//
// Copyright (c) Microsoft. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#import "CGPathApplyViewController.h"
#import "CGDrawView.h"

@implementation CGPathApplyViewController

- (void)loadView {
    [super loadView];

    CGDrawView* cgView = [[CGDrawView alloc] initWithFrame:self.view.bounds drawOptions:self.options];

    [cgView setDrawBlock:^(void) {
        CGContextRef currentContext = UIGraphicsGetCurrentContext();

        CGContextSetLineWidth(currentContext, self.options.lineWidth);
        CGContextSetStrokeColorWithColor(currentContext, self.options.lineColor);
        CGContextSetLineDash(currentContext, self.options.linePhase, self.options.lineDashPattern, self.options.lineDashCount);

        CGMutablePathRef thepath = CGPathCreateMutable();

        CGPathMoveToPoint(thepath, NULL, 200, 35);
        CGPathAddLineToPoint(thepath, NULL, 165, 100);
        CGPathAddLineToPoint(thepath, NULL, 100, 100);
        CGPathAddLineToPoint(thepath, NULL, 150, 150);
        CGPathAddLineToPoint(thepath, NULL, 135, 225);
        CGPathAddLineToPoint(thepath, NULL, 200, 170);
        CGPathAddLineToPoint(thepath, NULL, 265, 225);
        CGPathAddLineToPoint(thepath, NULL, 250, 150);
        CGPathAddLineToPoint(thepath, NULL, 300, 100);
        CGPathAddLineToPoint(thepath, NULL, 235, 100);
        // This function draws a line from the center of the star (200,125) to each segment's starting point.
        CGPathApply(thepath, currentContext, CGPathApplyCallback);

        // Unnecessary as close subpath will finish this line off but for the sake of consistency, have this here.
        CGPathAddLineToPoint(thepath, NULL, 200, 35);

        CGPathCloseSubpath(thepath);
        CGContextAddPath(currentContext, thepath);
        CGContextStrokePath(currentContext);

        CGPathRelease(thepath);

        UIImage* comparisonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PathApply" ofType:@"png"]];
        CGAffineTransform flip = CGAffineTransformMakeScale(1, -1);
        CGAffineTransform shift = CGAffineTransformTranslate(flip, 0, comparisonImage.size.height * -1);
        CGContextConcatCTM(currentContext, shift);

        UIGraphicsBeginImageContext(comparisonImage.size);
        CGContextDrawImage(currentContext,
                           CGRectMake(50, -300, comparisonImage.size.width, comparisonImage.size.height),
                           comparisonImage.CGImage);
    }];

    [self.view addSubview:cgView];

    [super addComparisonLabel];
}

static void CGPathApplyCallback(void* context, const CGPathElement* element) {
    CGPoint* points = element->points;
    CGContextMoveToPoint(context, 200, 125);
    CGContextAddLineToPoint(context, points[0].x, points[0].y);
    CGContextStrokePath(context);
}

@end
