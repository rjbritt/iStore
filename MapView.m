//
//  MapView.m
//  ClientApp
//
//  Created by Chris Bobo on 10/31/11.
//  Copyright 2011 Clemson University. All rights reserved.
//

#import "MapView.h"
#import "ProductsView.h"
#import "MyClass.h"
#import "ClientAppAppDelegate.h"
#import "ClientAppViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "StoreLocation.h"

@implementation MapView 
@synthesize mapView;
@synthesize useCurrentLocation;
@synthesize storeId;

- (IBAction)pushBack:(id)sender {
	ClientAppViewController *locationInputView =[[ClientAppViewController alloc] initWithNibName:nil bundle:nil];
    locationInputView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:locationInputView animated:YES];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
		
    addressClicked = view.annotation.subtitle;
    
    ClientAppAppDelegate *addressClickedAppDelegate = (ClientAppAppDelegate*)([[UIApplication sharedApplication] delegate]);
    addressClickedAppDelegate.storeIdAppDelegate = addressClicked;
        
    [self pushProductsView:self];
}

-(CLLocationCoordinate2D) convertAddressToCoordinates: (NSString *) address{
    
    NSError* error = nil;
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
                           [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
    
    double latitude = 0.0;
    double longitude = 0.0;
    
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else {
        //Show error
    }
    
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    
    return location;
}

-(IBAction)currentLocation:(id)sender{
    
    //Go through a temporary list of addresses and convert then to coordinates
    //Then add the annotations
    NSArray *listOfAddresses;
    CLLocationCoordinate2D currentAddress;
    MKCoordinateRegion tempRegion = { {0.0, 0.0 }, {0.0, 0.0 } };
    
    ClientAppAppDelegate *storeListReceivingAppDelegate = (ClientAppAppDelegate*)([[UIApplication sharedApplication] delegate]);
    listOfAddresses = storeListReceivingAppDelegate.storeAddressList;
    
    int i;
    for (i=0; i<[listOfAddresses count]; i++) {
        MyClass *currentAnnotation = [[MyClass alloc] init];
        StoreLocation *tempAddress = [[StoreLocation alloc] init];
        tempAddress = [listOfAddresses objectAtIndex:i];
        currentAddress = [self convertAddressToCoordinates:tempAddress.storeAddress];
        
        CLLocation *currentAddressObject = [[CLLocation alloc] initWithLatitude:currentAddress.latitude longitude:currentAddress.longitude];
        [listOfCoordinates addObject:currentAddressObject];
        
        tempRegion.center = currentAddress;
        tempRegion.span.latitudeDelta = 0.01f;
        tempRegion.span.longitudeDelta = 0.01f;
        [mapView setRegion:tempRegion animated:YES];
        
        currentAnnotation.title = [NSString stringWithFormat:@"Bi-Lo %i",i+1];
        currentAnnotation.subtitle = ((StoreLocation*)[listOfAddresses objectAtIndex:i]).storeAddress;
        currentAnnotation.coordinate = tempRegion.center;
        [mapView addAnnotation:currentAnnotation];
        [currentAnnotation release];
        [currentAddressObject release];
    }
    
    //Do normal current location stuff
    CLLocationCoordinate2D location;
    
    location.latitude  = locationManager.location.coordinate.latitude; 
    location.longitude = locationManager.location.coordinate.longitude;
    
    theCurrentLocation = location;
    
    MKCoordinateRegion region = { {0.0, 0.0 }, {0.0, 0.0 } };
    region.center = location;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [mapView setRegion:region animated:YES];
    
    MyClass *annotation = [[MyClass alloc] init];
//    annotation.title = @"Current Location";
//    annotation.subtitle = addressField.text;
    
    annotation.coordinate = region.center;
    
    [mapView addAnnotation:annotation];
    
    [addressField resignFirstResponder];
    
}

-(IBAction)setMap:(id)sender{
    switch (((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            mapView.mapType = MKMapTypeHybrid;
            break;
            
        default:
            break;
    }
}

- (IBAction)pushProductsView:(id)sender {
	ProductsView *productsview =[[ProductsView alloc] initWithNibName:nil bundle:nil];
    productsview.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:productsview animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [mapView setMapType:MKMapTypeStandard];
        [mapView setZoomEnabled:YES];
        [mapView setScrollEnabled:YES];
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        [locationManager startUpdatingLocation];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(CLLocationCoordinate2D) addressLocation {
    ClientAppAppDelegate *appDelegate = (ClientAppAppDelegate*)([[UIApplication sharedApplication] delegate]);
    int zipCode = appDelegate.locationZipCode;
    
    NSString *address = [NSString stringWithFormat:@"%i", zipCode];
    NSError* error = nil;
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
                           [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
    
    double latitude = 0.0;
    double longitude = 0.0;
    
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else {
        //Show error
    }
    
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    
    return location;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    ClientAppAppDelegate *appDelegate = (ClientAppAppDelegate*)([[UIApplication sharedApplication] delegate]);

    if(appDelegate.useCurrentLocation)
    {
        [self currentLocation:self];
    }
    appDelegate.useCurrentLocation = NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //Update location manager
    
    ClientAppAppDelegate *appDelegate = (ClientAppAppDelegate*)([[UIApplication sharedApplication] delegate]);
    
    if(!appDelegate.useCurrentLocation)
    {
        [self goToButton:self];
    }
}

//Create the annotation for pins
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    
    id temp = annotation;
    //annView.pinColor = MKPinAnnotationColorGreen;
    annView.image = [UIImage imageNamed:@"leafLogo3.png"];
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    //Give the annotation a button
    UIButton *annotationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationButton.titleLabel.text = temp;
    [annotationButton addTarget:self action:@selector(annotationAction:) forControlEvents:UIControlEventTouchUpInside];
    annView.rightCalloutAccessoryView = annotationButton;
    return annView;
}

//Code for what happens when the button on the annotation on a pin is clicked
- (void) annotationAction:(UIButton *)button 
{

}

- (IBAction)goToButton:(id)sender {
   
    //Go through the list of addresses and convert then to coordinates
    //Then add the annotations
    NSArray *listOfAddresses;
    CLLocationCoordinate2D currentAddress;
    //MyClass *currentAnnotation = [[MyClass alloc] init];
    MKCoordinateRegion tempRegion = { {0.0, 0.0 }, {0.0, 0.0 } };

    ClientAppAppDelegate *storeListReceivingAppDelegate = (ClientAppAppDelegate*)([[UIApplication sharedApplication] delegate]);
    listOfAddresses = storeListReceivingAppDelegate.storeAddressList;
    
    int i;
    for (i=0; i<[listOfAddresses count]; i++) {
        
        MyClass *currentAnnotation = [[MyClass alloc] init];
        StoreLocation *tempAddress = [[StoreLocation alloc] init];
        tempAddress = [listOfAddresses objectAtIndex:i];
        currentAddress = [self convertAddressToCoordinates:tempAddress.storeAddress];
        
        CLLocation *currentAddressObject = [[CLLocation alloc] initWithLatitude:currentAddress.latitude longitude:currentAddress.longitude];
        [listOfCoordinates addObject:currentAddressObject];

        tempRegion.center = currentAddress;
        tempRegion.span.latitudeDelta = 0.01f;
        tempRegion.span.longitudeDelta = 0.01f;
        [mapView setRegion:tempRegion animated:YES];
        
        currentAnnotation.title = [NSString stringWithFormat:@"Bi-Lo %i",i+1];
        currentAnnotation.subtitle = ((StoreLocation*)[listOfAddresses objectAtIndex:i]).storeAddress;
        currentAnnotation.coordinate = tempRegion.center;
        [mapView addAnnotation:currentAnnotation];
        [currentAnnotation release];
    }
    
    //Do normal zipcode stuff
    CLLocationCoordinate2D location = [self addressLocation];
    
    MKCoordinateRegion region = { {0.0, 0.0 }, {0.0, 0.0 } };
    region.center = location;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [mapView setRegion:region animated:YES];
    
    MyClass *annotation = [[MyClass alloc] init];
    annotation.title = @"Zip Code";
    annotation.subtitle = addressField.text;
    annotation.coordinate = region.center;
    [mapView addAnnotation:annotation];
    
    [addressField resignFirstResponder];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
