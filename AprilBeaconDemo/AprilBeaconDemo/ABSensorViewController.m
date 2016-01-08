//
//  ABSensorViewController.m
//  Examples
//
//  Created by liaojinhua on 14-7-3.
//  Copyright (c) 2014年 li shuai. All rights reserved.
//

#import "ABSensorViewController.h"

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;

const Vertex Vertices[] = {
    // Front
    {{1, -1, 1}, {1, 0, 0, 1}, {1, 0}},
    {{1, 1, 1}, {1, 0, 0, 1}, {1, 1}},
    {{-1, 1, 1}, {1, 0, 0, 1}, {0, 1}},
    {{-1, -1, 1}, {1, 0, 0, 1}, {0, 0}},
    // Back
    {{1, 1, -1}, {0, 1, 0, 1}, {0, 1}},
    {{-1, -1, -1}, {0, 1, 0, 1}, {1, 0}},
    {{1, -1, -1}, {0, 1, 0, 1}, {0, 0}},
    {{-1, 1, -1}, {0, 1, 0, 1}, {1, 1}},
    // Left
    {{-1, -1, 1}, {0, 0, 1, 1}, {1, 0}},
    {{-1, 1, 1}, {0, 0, 1, 1}, {1, 1}},
    {{-1, 1, -1}, {0, 0, 1, 1}, {0, 1}},
    {{-1, -1, -1}, {0, 0, 1, 1}, {0, 0}},
    // Right
    {{1, -1, -1}, {0.5, 0, 0.5, 1}, {1, 0}},
    {{1, 1, -1}, {0.5, 0, 0.5, 1}, {1, 1}},
    {{1, 1, 1}, {0.5, 0, 0.5, 1}, {0, 1}},
    {{1, -1, 1}, {0.5, 0, 0.5, 1}, {0, 0}},
    // Top
    {{1, 1, 1}, {0.5, 0.5, 0, 1}, {1, 0}},
    {{1, 1, -1}, {0.5, 0.5, 0, 1}, {1, 1}},
    {{-1, 1, -1}, {0.5, 0.5, 0, 1}, {0, 1}},
    {{-1, 1, 1}, {0.5, 0.5, 0, 1}, {0, 0}},
    // Bottom
    {{1, -1, -1}, {0, 0.5, 0.5, 1}, {1, 0}},
    {{1, -1, 1}, {0, 0.5, 0.5, 1}, {1, 1}},
    {{-1, -1, 1}, {0, 0.5, 0.5, 1}, {0, 1}},
    {{-1, -1, -1}, {0, 0.5, 0.5, 1}, {0, 0}}
};

const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 6, 5,
    4, 5, 7,
    // Left
    8, 9, 10,
    10, 11, 8,
    // Right
    12, 13, 14,
    14, 15, 12,
    // Top
    16, 17, 18,
    18, 19, 16,
    // Bottom
    20, 21, 22,
    22, 23, 20
};




@interface ABSensorViewController () <UIAlertViewDelegate>
{
//    MBProgressHUD *_mbp;
    
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    GLuint _vertexArray;
    float _rotation;
    GLKMatrix4 _rotMatrix;
    GLKVector3 _anchor_position;
    GLKVector3 _current_position;
    GLKQuaternion _quatStart;
    GLKQuaternion _quat;
    
    BOOL _slerping;
    float _slerpCur;
    float _slerpMax;
    GLKQuaternion _slerpStart;
    GLKQuaternion _slerpEnd;
}


@property (nonatomic, strong) CBCharacteristic *accCharacteristic;
@property (nonatomic, strong) CBCharacteristic *accDataCharacteristic;
@property (nonatomic, strong) CBCharacteristic *lightCharacteristic;
@property (nonatomic, strong) CBCharacteristic *lightDataCharacteristic;

@property (nonatomic) BOOL dataUpdated;

@property (nonatomic) float angleAccX;
@property (nonatomic) float angleAccY;
@property (nonatomic) float angleAccZ;

@property (nonatomic) double light;

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;
@property (weak, nonatomic) IBOutlet UISwitch *accSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lightSwitch;

@end

@implementation ABSensorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.sensor.peripheral.name;
    [self initGLData];
    [self setupGL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.sensor.delegate = self;
    [self connectToPeripheral];
    __weak ABSensorViewController *wSelf = self;
    [self.sensor setAccValueChangedBlock:^(ABAcceleration acceleration) {
        CGFloat Ax = acceleration.x;
        CGFloat Ay = acceleration.y;
        CGFloat Az = acceleration.z;
        wSelf.angleAccX = atan(Ax/sqrt(Az*Az+Ay*Ay))*180/3.14;
        wSelf.angleAccY = atan(Ay/sqrt(Ax*Ax+Az*Az))*180/3.14;
        wSelf.angleAccZ = atan(Az/sqrt(Ax*Ax+Ay*Ay))*180/3.14;
        wSelf.dataUpdated = YES;
    }];
    
    [self.sensor setLightValueChangedBlock:^(double light) {
        wSelf.light = light;
        wSelf.dataUpdated = YES;
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sensor disconnectBeacon];
    [self.sensor setAccValueChangedBlock:nil];
    [self.sensor setLightValueChangedBlock:nil];
    self.sensor.delegate = nil;
}

- (void)connectToPeripheral
{
    [self.sensor connectToBeacon];
    [self showProgress:@"Connecting Device"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchValueChanged:(UISwitch *)sender
{
    UInt8 value = 0;
    if (sender.on) {
        value = 1;
    }
    if (sender == self.accSwitch) {
        [self.sensor setAccelerometerOn:value WithCompletion:nil];
    } else {
        [self.sensor setLightSensorOn:value WithCompletion:nil];
    }
}

- (void)showProgress:(NSString *)title
{
//    _mbp = [[MBProgressHUD alloc] initWithView:self.view];
//    _mbp.labelText = title;
//    [self.view addSubview:_mbp];
//    [_mbp show:YES];
}

- (void)hideProgress
{
//    [_mbp removeFromSuperview];
}

- (void)initGLData
{
    self.angleAccX = 0.0;
    self.angleAccY = 0.0;
    self.angleAccZ = 0.0;
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableMultisample = GLKViewDrawableMultisample4X;
}

- (void)setupGL {
    
    [EAGLContext setCurrentContext:self.context];
    glEnable(GL_CULL_FACE);
    
    self.effect = [[GLKBaseEffect alloc] init];
    
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:YES],
                              GLKTextureLoaderOriginBottomLeft,
                              nil];
    
    NSError * error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tile_floor" ofType:@"png"];
    GLKTextureInfo * info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (info == nil) {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }
    self.effect.texture2d0.name = info.name;
    self.effect.texture2d0.enabled = true;
    
    // New lines
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    // Old stuff
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
    // New lines (were previously in draw)
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, TexCoord));
    
    // New line
    glBindVertexArrayOES(0);
    
    _rotMatrix = GLKMatrix4Identity;
    _quat = GLKQuaternionMake(0, 0, 0, 1);
    _quatStart = GLKQuaternionMake(0, 0, 0, 1);
}

- (void)tearDownGL {
    
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    
    self.effect = nil;
    
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(200.0, 200.0, 200.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.effect prepareToDraw];
    
    glBindVertexArrayOES(_vertexArray);
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    
}

#pragma mark - GLKViewControllerDelegate

- (void)update {
    if(self.dataUpdated){
        self.dataUpdated = false;
        self.xLabel.text = [NSString stringWithFormat:@"X：%.2f", self.angleAccX];
        self.yLabel.text = [NSString stringWithFormat:@"Y：%.2f", self.angleAccY];
        self.zLabel.text = [NSString stringWithFormat:@"Z：%.2f", self.angleAccZ];
        self.lightLabel.text = [NSString stringWithFormat:@"Light：%.f", self.light];
    }
    
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 4.0f, 10.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    if (_slerping) {
        
        _slerpCur += self.timeSinceLastUpdate;
        float slerpAmt = _slerpCur / _slerpMax;
        if (slerpAmt > 1.0) {
            slerpAmt = 1.0;
            _slerping = NO;
        }
        
        _quat = GLKQuaternionSlerp(_slerpStart, _slerpEnd, slerpAmt);
    }
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);
    /*
     //modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, _rotMatrix);
     GLKMatrix4 rotation = GLKMatrix4MakeWithQuaternion(_quat);
     modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, rotation);
     */
    //_rotation += 90 * self.timeSinceLastUpdate;
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(self.angleAccY), 1, 0, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(-self.angleAccX), 0, 1, 0);
    //    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(self.angleAccZ), 0, 0, 1);
    
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
}

- (GLKVector3) projectOntoSurface:(GLKVector3) touchPoint
{
    float radius = self.view.bounds.size.width/3;
    GLKVector3 center = GLKVector3Make(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 0);
    GLKVector3 P = GLKVector3Subtract(touchPoint, center);
    
    // Flip the y-axis because pixel coords increase toward the bottom.
    P = GLKVector3Make(P.x, P.y * -1, P.z);
    
    float radius2 = radius * radius;
    float length2 = P.x*P.x + P.y*P.y;
    
    if (length2 <= radius2)
        P.z = sqrt(radius2 - length2);
    else
    {
        /*
         P.x *= radius / sqrt(length2);
         P.y *= radius / sqrt(length2);
         P.z = 0;
         */
        P.z = radius2 / (2.0 * sqrt(length2));
        float length = sqrt(length2 + P.z * P.z);
        P = GLKVector3DivideScalar(P, length);
    }
    
    return GLKVector3Normalize(P);
}

- (void)computeIncremental {
    
    GLKVector3 axis = GLKVector3CrossProduct(_anchor_position, _current_position);
    float dot = GLKVector3DotProduct(_anchor_position, _current_position);
    float angle = acosf(dot);
    
    GLKQuaternion Q_rot = GLKQuaternionMakeWithAngleAndVector3Axis(angle * 2, axis);
    Q_rot = GLKQuaternionNormalize(Q_rot);
    
    // TODO: Do something with Q_rot...
    _quat = GLKQuaternionMultiply(Q_rot, _quatStart);
}

- (void)beaconConnectionDidSucceeded:(ABBeacon *)beacon
{
    
}

- (void)beaconDidDisconnect:(ABBeacon *)beacon withError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSInternalInconsistencyException message:@"已断开连接，请重现尝试" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
