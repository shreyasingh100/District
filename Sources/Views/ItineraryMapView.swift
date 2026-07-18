import SwiftUI
import MapKit

struct ItineraryMapView: UIViewRepresentable {
    let timeline: [TimelineBlock]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.overrideUserInterfaceStyle = .dark
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = false
        mapView.layer.cornerRadius = 24
        mapView.clipsToBounds = true
        
        // Configure map appearance
        let mapConfig = MKStandardMapConfiguration(emphasisStyle: .muted)
        mapConfig.pointOfInterestFilter = .excludingAll
        mapView.preferredConfiguration = mapConfig
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Remove existing annotations and overlays
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        var coordinates: [CLLocationCoordinate2D] = []
        
        // Add pins for each stop
        for (index, block) in timeline.enumerated() {
            if let firstItem = block.items.first {
                let annotation = StopAnnotation(
                    coordinate: firstItem.coordinate,
                    title: block.title,
                    subtitle: block.time,
                    icon: block.icon,
                    index: index
                )
                mapView.addAnnotation(annotation)
                coordinates.append(firstItem.coordinate)
            }
        }
        
        // Draw route polyline
        if coordinates.count >= 2 {
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
        }
        
        // Fit map to show all pins
        if !coordinates.isEmpty {
            let region = regionForCoordinates(coordinates)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    private func regionForCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        var minLat = coordinates[0].latitude
        var maxLat = coordinates[0].latitude
        var minLon = coordinates[0].longitude
        var maxLon = coordinates[0].longitude
        
        for coord in coordinates {
            minLat = min(minLat, coord.latitude)
            maxLat = max(maxLat, coord.latitude)
            minLon = min(minLon, coord.longitude)
            maxLon = max(maxLon, coord.longitude)
        }
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.6 + 0.005,
            longitudeDelta: (maxLon - minLon) * 1.6 + 0.005
        )
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let stopAnnotation = annotation as? StopAnnotation else { return nil }
            
            let identifier = "StopPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }
            
            annotationView?.glyphText = stopAnnotation.icon
            annotationView?.markerTintColor = UIColor(red: 184/255, green: 164/255, blue: 248/255, alpha: 1.0)
            annotationView?.titleVisibility = .adaptive
            annotationView?.subtitleVisibility = .adaptive
            annotationView?.displayPriority = .required
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor(red: 184/255, green: 164/255, blue: 248/255, alpha: 0.8)
                renderer.lineWidth = 3
                renderer.lineDashPattern = [8, 4]
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

// MARK: - Custom Annotation

class StopAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let icon: String
    let index: Int
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, icon: String, index: Int) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.index = index
        super.init()
    }
}
