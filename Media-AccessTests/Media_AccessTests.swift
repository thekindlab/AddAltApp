import XCTest

class Media_AccessTests: XCTestCase{

    override func setUp()
    {
        super.setUp()
    }

    override func tearDown()
    {
        super.tearDown()

    }

    func test_AlbumDownloadEmpty() //critical value of downloading 0 images
    {
        
        XCTAssertEqual(-1,0)
    }

    func test_AlbumDownloadCaptionedImage()  //representative case of downloading a regular image
    {
        XCTAssertEqual(-1,0)
    
    }

    func test_AlbumDownloadUnCaptionedImage() //critical test case of downloading an unCaptioned Image
    {
        XCTAssertEqual(-1,0)
    
    
    }

    func test_AlbumDownloadMaxNumberOfCaptionedImage() //critical test case of downloading the maxiumum number of images at once.
    {
        XCTAssertEqual(-1,0)
    }

    func test_AlbumNotificationOnPhotoAdd() //representative test case of notification when photo is added to library
    {
        XCTAssertEqual(-1,0)
    
    }

    func test_PickPhoto_Image_1()  //representative test case of picking a photo
    {
        XCTAssertEqual(-1,0)
    
    }

    func test_PickPhoto_Image_2()  //representative test case of picking a photo
    {
        XCTAssertEqual(-1,0)
    
    }

    

    func test_RemovePhoto_Image_1() //representative test case of removing a test photo
    {
        XCTAssertEqual(-1,0)
    }


    func test_RemovePhoto_Image_2() //representative test case of removing a test photo
    {
        XCTAssertEqual(-1,0)
    }


    func test_RemoveAllPhotos() //critical test case of removing all chosen photos
    {
    
        XCTAssertEqual(-1,0)
    }


}
