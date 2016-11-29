import XCTest
@testable import Bignum

class BignumTests: XCTestCase {
	/// Test simple arithmetics
	func testArithmetics() {
		let a: BigInt = 10
		let b: BigInt = 7
		let c = a + b
		XCTAssertEqual(c, 17)
		let d = a - b
		XCTAssertEqual(d, 3)
		let e = a * b
		XCTAssertEqual(e, 70)
		let f = a / b
		XCTAssertEqual(f, 1)
		let g = a % b
		XCTAssertEqual(g, 3)
		let h: BigInt = -10
		XCTAssertEqual(-a, h)
		let i = a + h
		XCTAssertEqual(i, 0)
		let j = a - h
		XCTAssertEqual(j, 20)
		let k = a * h
		XCTAssertEqual(k, -100)
		let l = a / h
		XCTAssertEqual(l, -1)
		let m = a % h
		XCTAssertEqual(m, 0)
		let n = b % h
		XCTAssertEqual(n, 7)
		let o = -h % b
		XCTAssertEqual(o, 3)
	}

	/// Test arithmetics with UInt
	func testUIntArithmetics() {
		let a: BigInt = 10
		let b = UInt(7)
		let c = a + b
		XCTAssertEqual(c, 17)
		let d = a - b
		XCTAssertEqual(d, 3)
		let e = a * b
		XCTAssertEqual(e, 70)
		let f = a / b
		XCTAssertEqual(f, 1)
		let g = a % b
		XCTAssertEqual(g, 3)
	}


	/// Test arithmetics with UInt
	func testSIntArithmetics() {
		let a: BigInt = 10
		let b = 7
		let c = a + b
		XCTAssertEqual(c, 17)
		let d = a - b
		XCTAssertEqual(d, 3)
		let e = a * b
		XCTAssertEqual(e, 70)
		let f = a / b
		XCTAssertEqual(f, 1)
		let h = -10
		XCTAssertEqual(-a, BigInt(h))
		let i = a + h
		XCTAssertEqual(i, 0)
		let j = a - h
		XCTAssertEqual(j, 20)
		let k = a * h
		XCTAssertEqual(k, -100)
		let l = a / h
		XCTAssertEqual(l, -1)
		let n = b % h
		XCTAssertEqual(n, 7)
		let o = -h % b
		XCTAssertEqual(o, 3)
	}
	
	/// Test conversion from a Hex string
	func testBigIntHex() {
		let s1 = "BadFeed"
		let i1 = 0xbadfeed
		let s2 = "785c8638a586c71843c374bcef11a9ab3810a6f2c88a4f8c06a3579ed8f957253979f2ce68535e6d70186e4979dedece044dddf2f59541dbba68082ff86168aba1afbe78e7889fbe438b672059ab2a05e1865e923d06fc1f2e8a642b"
		let b1a = BigInt(hex: s1)
		let b1b = BigInt(i1)
		let b1h = s1.lowercased()
		XCTAssertEqual(b1a, b1b)
		XCTAssertEqual(b1a.hex, b1h)
		let b2 = BigInt(hex: s2)
		XCTAssertEqual(b2.hex, s2)
	}

	/// Test conversion from a 64 bit integer
	func testUInt64() {
		let i1 = UInt64(0x12345678abcdefab)
		let b1 = 0x12345678abcdefab
		XCTAssertEqual(b1.description, "\(i1)")
	}

	/// Test conversion from Data
	func testFromData() {
		let a: ContiguousArray<UInt8> = [ 0xab, 0xcd, 0xef, 0x01, 0x23, 0x45, 0x67, 0x89, 0x0f, 0x1e, 0x2d, 0x3c, 0x4b, 0x5c, 0x6b, 0x7a]
		let d = a.withUnsafeBytes { Data(bytes: $0.baseAddress!, count: $0.count) }
		let b = BigInt(data: d)
		XCTAssertEqual(b.hex, "abcdef01234567890f1e2d3c4b5c6b7a")
	}

	/// Test conversion to Data
	func testToData() {
		let s = "abcdef01234567890f1e2d3c4b5c6b7a"
		let a = BigInt(hex: s)
		let d = a.data
		let b = BigInt(data: d)
		XCTAssertEqual(a, b)
		XCTAssertEqual(d.hexString, s)
	}

	func testPerformanceData() {
		let a: ContiguousArray<UInt8> = [ 0xab, 0xcd, 0xef, 0x01, 0x23, 0x45, 0x67, 0x89, 0x0f, 0x1e, 0x2d, 0x3c, 0x4b, 0x5c, 0x6b, 0x7a]
		let d = a.withUnsafeBytes { Data(bytes: $0.baseAddress!, count: $0.count) }
		let n = 10000
		var b = Array<BigInt>(repeating: BigInt(0), count: n)
		self.measure {
			for i in 0..<n {
				b[i] = BigInt(data: d)
			}
		}
		XCTAssertEqual(b[5].hex, "abcdef01234567890f1e2d3c4b5c6b7a")
	}

	/// Test modulo and nnmod()
	func testMod() {
		let a = BigInt("100000000000000000000000000000000000000000000000000")
		let m = BigInt("60000000000000000000000000000000000000000000000000")
		let r = a % m
		XCTAssertEqual(r, BigInt("40000000000000000000000000000000000000000000000000"))
		let b = -a
		let n = b % m
		XCTAssertEqual(n, BigInt("-40000000000000000000000000000000000000000000000000"))
		let o = -m
		let p = a % o
		XCTAssertEqual(p, BigInt("40000000000000000000000000000000000000000000000000"))
		let q = b % o
		XCTAssertEqual(q, BigInt("-40000000000000000000000000000000000000000000000000"))
		let s = nnmod(b, m)
		XCTAssertEqual(s, BigInt("20000000000000000000000000000000000000000000000000"))
		let t = nnmod(b, o)
		XCTAssertEqual(t, BigInt("20000000000000000000000000000000000000000000000000"))
	}

	/// Test mod_add()
	func testModAdd() {
		let a = BigInt("100000000000000000000000000000000000000000000000000")
		let b = BigInt("10000000000000000000000000000000000000000000000000")
		let m = BigInt("60000000000000000000000000000000000000000000000000")
		let c = mod_add(a, b, m)
		XCTAssertEqual(c, BigInt("50000000000000000000000000000000000000000000000000"))
		let e = mod_add(-a, b, m)
		XCTAssertEqual(e, BigInt("30000000000000000000000000000000000000000000000000"))
		let f = mod_add(-a, -b, -m)
		XCTAssertEqual(f, BigInt("10000000000000000000000000000000000000000000000000"))
	}

	
	/// Test mod_exp()
	func testModExp() {
		let base = BigInt(4)
		let exponent = BigInt(13)
		let modulus = BigInt(497)
		let expected = BigInt(445)
		let actual = mod_exp(base, exponent, modulus)
		XCTAssertEqual(actual, expected)
		let b2 = BigInt(hex: "785c8638a586c71843c374bcef11a9ab3810a6f2c88a4f8c06a3579ed8f957253979f2ce68535e6d70186e4979dedece044dddf2f59541dbba68082ff86168aba1afbe78e7889fbe438b672059ab2a05e1865e923d06fc1f2e8a642b")
		let e2 = BigInt(hex: "abcdef01234567890f1e2d3c4b5c6b78abcd")
		let m2 = BigInt(hex: "0fb7c06ab37c13ae795c2f7c2c9586ce5")
		let x2 = BigInt("217502968925063512482169013127834968915")
		let a2 = mod_exp(b2, e2, m2)
		XCTAssertEqual(a2, x2)
	}

	/// Test performance of mod_exp()
	func testPerformanceModExp() {
		let b = BigInt(hex: "785c8638a586c71843c374bcef11a9ab3810a6f2c88a4f8c06a3579ed8f957253979f2ce68535e6d70186e4979dedece044dddf2f59541dbba68082ff86168aba1afbe78e7889fbe438b672059ab2a05e1865e923d06fc1f2e8a642b")
		let e = BigInt(hex: "abcdef01234567890f1e2d3c4b5c6b78abcd785c8638a586c71843c374bcef11a9ab3810a6f2c88a4f8c06a3579ed8f957253979f2ce68535e6d70186e4979dedece044dddf2f59541dbba68082ff86168aba1afbe78e7889fbe438b672059ab2a05e1865e923d06fc1f2e8a642b")
		let m = BigInt(hex: "0fb7c06ab37c13ae217502968925063512482169013127834968915795c2f7c2c9586ce5")
		let x = BigInt("28082478406493690655098710217842834345687220303347034179225810911513400721173064790303")
		var a = BigInt(0)
		measure {
			a = mod_exp(b, e, m)
		}
		XCTAssertEqual(a, x)
	}

	static var allTests : [(String, (BignumTests) -> () throws -> Void)] {
		return [
			("testArithmetics",     testArithmetics),
			("testUIntArithmetics", testUIntArithmetics),
			("testSIntArithmetics", testSIntArithmetics),
			("testBigIntHex",       testBigIntHex),
			("testUInt64",			testUInt64),
			("testFromData",		testFromData),
			("testToData",			testToData),
			("testMod",				testMod),
			("testModAdd",			testModAdd),
			("testModExp",			testModExp),
			("testPerformanceModExp",	testPerformanceModExp),
			("testPerformanceData",	testPerformanceData),
		]
	}
}
