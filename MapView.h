//
//  MapView.h
//  ClientApp
//
//  Created by Chris Bobo on 10/31/11.
//  Copyright 2011 Clemson University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapView : UIViewController <CLLocationManagerDelegate>{
    MKMapView *mapView;
    IBOutlet UITextField *addressField;
    CLLocationManager *locationManager;
    
    NSArray *tempAddresses;
    NSMutableArray *listOfCoordinates;
    
    NSString *addressClicked;
    
    CLLocationCoordinate2D theCurrentLocation;

}
//Represents which store was selected
@property (copy) NSString *storeId;
@property BOOL useCurrentLocation; // boolean whether to use the current location or to use the zip code.
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
-(IBAction)setMap:(id)sender;
-(IBAction)pushBack:(id)sender;
-(IBAction)currentLocation:(id)sender;

-(IBAction)pushProductsView:(id)sender;
-(IBAction)goToButton:(id)sender;

@end
