
struct LoginModel : Codable {
	let user : User?
	let access_token : String?
}
struct User : Codable {
    let id : Int?
}
