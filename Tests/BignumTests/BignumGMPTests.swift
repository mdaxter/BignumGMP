import XCTest
import Foundation
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

	#if !os(Linux)
	/// Test conversion from Data
	func testFromData() {
		let a: ContiguousArray<UInt8> = [ 0xab, 0xcd, 0xef, 0x01, 0x23, 0x45, 0x67, 0x89, 0x0f, 0x1e, 0x2d, 0x3c, 0x4b, 0x5c, 0x6b, 0x7a]
		let d = a.withUnsafeBytes { Data(bytes: $0.baseAddress!, count: $0.count) }
		let b = BigInt(data: d)
		XCTAssertEqual(b.hex.lowercased(), "abcdef01234567890f1e2d3c4b5c6b7a")
		let z = Data()
		let n = Bignum(data: z)
		XCTAssertEqual(n, Bignum(0))
		let f = Data(bytes: [5])
		let g = Bignum(data: f)
		XCTAssertEqual(g, Bignum("5"))
	}
	#endif

	/// Test conversion to Data
	func testToData() {
		let s = "abcdef01234567890f1e2d3c4b5c6b7a"
		let a = BigInt(hex: s)
		let d = a.data
		let b = BigInt(data: d)
		XCTAssertEqual(a, b)
		XCTAssertEqual(d.hexString, s)
		let c = Bignum(hex: "5")
		let t = Data(bytes: [5])
		XCTAssertEqual(c.data, t)
		let z = Bignum(hex: "0")
		XCTAssertEqual(z.data, Data())
	}

	#if !os(Linux)
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
	#endif

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

	func testAMK() {
		let A = Bignum(hex: "45ea419f048d127a3ef97da346da44730c04db024de47dc29eb68045ca97aadf7aadd823ff6b5c87b3e1cc319e2741f1da63aa0cfe57a215e22efa8976e52841a8a55cad506c998c5d387776108a471bca1bccc6ebb47b3a2e95f0a58c6a90ae24039d4eddba28c94d5c33f0f6ea1b8f497359240738d6511558f8bd01d9ff5d8f40bc35dd72d652d748ed2fb8595fb71ad3f4d2014938a70e9c348c50d93018273207c022f21f229185df7dba9cc580f336b1cca23ae6a0174412f626a4d9463835e68a3edce64b3a3465ba07dda0df9eaca571bdc8a7d1dbf8616f940d5b29abcd7b1f1676e95d463d2acb9cad77e383fa606d857fb6a27c6251b4321ec96059d1d12fa7ff840e15e338b4239337a4202c79bf357b71312a74d88a6ceaa9d9906cac06c6eb5dcfe7bd55ee2af76a1dcb61ba989752d508601e47974d7524a530aba50029f10a5441c0138c43e14c3607e5580104c3f26ac2707cd7d99604598c7f48659037eb99a9dc579a2c94f8ac1663d8833e711ecfb97f33baef21f407")
		let M = Bignum(hex: "7F63716CEE2F305836D929F6CDCA6ED71B9C58BE89AE3126D59ED5590E2B1317B72F1E7CF1F8F6F0D889954E4265212DBAEAD69CA4E5E3F64927654FED2083BD")
		let K = Bignum(hex: "ba401483ae98c150d1b784bfee76ebcc66015f6cc5695a4986734af203a01a8ee12c3203250d112bd4c1207e60c78b68a46a50200e69504f9bb8b165389db060")
		let AMK = Bignum(hex: "45EA419F048D127A3EF97DA346DA44730C04DB024DE47DC29EB68045CA97AADF7AADD823FF6B5C87B3E1CC319E2741F1DA63AA0CFE57A215E22EFA8976E52841A8A55CAD506C998C5D387776108A471BCA1BCCC6EBB47B3A2E95F0A58C6A90AE24039D4EDDBA28C94D5C33F0F6EA1B8F497359240738D6511558F8BD01D9FF5D8F40BC35DD72D652D748ED2FB8595FB71AD3F4D2014938A70E9C348C50D93018273207C022F21F229185DF7DBA9CC580F336B1CCA23AE6A0174412F626A4D9463835E68A3EDCE64B3A3465BA07DDA0DF9EACA571BDC8A7D1DBF8616F940D5B29ABCD7B1F1676E95D463D2ACB9CAD77E383FA606D857FB6A27C6251B4321EC96059D1D12FA7FF840E15E338B4239337A4202C79BF357B71312A74D88A6CEAA9D9906CAC06C6EB5DCFE7BD55EE2AF76A1DCB61BA989752D508601E47974D7524A66A4F2AF0C6B8FBFD4A50C2430022A6D98983102C53DB7DDB1E829D22EB61320024DA98E5A73DF3B657270D66CFC1A54275B8FF3FF1C053159E5F4A7014E02824")
		XCTAssertEqual(A + M + K, AMK)
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
			("testArithmetics",		testArithmetics),
			("testUIntArithmetics",		testUIntArithmetics),
			("testSIntArithmetics",		testSIntArithmetics),
			("testBigIntHex",		testBigIntHex),
			("testToData",			testToData),
			("testMod",			testMod),
			("testModAdd",			testModAdd),
			("testModExp",			testModExp),
			("testAMK",			testAMK),
			("testPerformanceModExp",	testPerformanceModExp),
		]
	}
}
