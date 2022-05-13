import Foundation

struct AppUser: Decodable {
    var UserId: String!
    var UserName: String!
    var UserEmail: String!
}

struct Place: Decodable {
    var PlaceId: String!
    var PlaceName: String!
    var PlaceDetails: String!
    var placeMainImage: String!
    var MoreImages: [String]!
    var likes: Int!
    var Reviews: [String]!
}
