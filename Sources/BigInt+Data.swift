//
//  BigInt+Data.swift
//  Bignum
//
//  NSData conversion for BigInt
//
//
import Foundation
import CGMP

public extension BigInt {
	/// Representation as Data.
	/// Note: this is only reversible for non-negative numbers.
	/// The storage format for negative numbers is undefined!
	public var data: Data {
		let m = Int(mpz._mp_size)
		let n = abs(m)
		guard n != 0 else { return Data() }
		//		guard n > 0 else {
		//			return Data()
		//		}
		let lbytes = Int(GMP_LIMB_BITS / 8)
		var data = Data(count: n * lbytes)
		data.withUnsafeMutableBytes { (ptr: UnsafeMutablePointer<UInt8>) -> Void in
			let limbs = __gmpz_limbs_read(&mpz)!
			var p = ptr
			for i in (0..<n).reversed() {
				for j in (0..<lbytes).reversed() {
					p.pointee = UInt8((limbs[i] >> mp_limb_t(j*8)) & 0xff)
					p += 1
				}
			}
		}
		return data
	}

	/// Initialise from big-endian data
	///
	/// - Parameter data: the data to convert to an unsigned BigInt
	public convenience init(data: Data) {
		self.init()
		let n = data.count
		guard n > 0 else { return }
		let lbytes = Int(GMP_LIMB_BITS / 8)
		let m = mp_size_t((n + (lbytes-1)) / lbytes)
		let limbs = __gmpz_limbs_write(&mpz, m)!
		defer { __gmpz_limbs_finish(&mpz, m) }
		data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) -> Void in
			var p = ptr
			let r = n % lbytes
			let k = (r == 0 ? lbytes : r) - 1
			limbs[m-1] = mp_limb_t(p.pointee) << mp_limb_t(k*8)
			p += 1
			for j in (0..<k).reversed() {
				limbs[m-1] += mp_limb_t(p.pointee) << mp_limb_t(j*8)
				p += 1
			}
			guard m > 1 else { return }
			let lb = lbytes - 1
			for i in (0..<(m-1)).reversed() {
				limbs[i] = mp_limb_t(p.pointee) << mp_limb_t(lb*8)
				p += 1
				for j in (0..<lb).reversed() {
					limbs[i] += mp_limb_t(p.pointee) << mp_limb_t(j*8)
					p += 1
				}
			}
		}
	}
}


/// Extension for Data to interoperate with Bignum
extension Data {
	/// Hexadecimal string representation of the underlying data
	var hexString: String {
		return withUnsafeBytes { (buf: UnsafePointer<UInt8>) -> String in
			let charA = UInt8(UnicodeScalar("a").value)
			let char0 = UInt8(UnicodeScalar("0").value)

			func itoh(_ value: UInt8) -> UInt8 {
				return (value > 9) ? (charA + value - 10) : (char0 + value)
			}

			let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: count * 2)

			for i in 0 ..< count {
				ptr[i*2] = itoh((buf[i] >> 4) & 0xF)
				ptr[i*2+1] = itoh(buf[i] & 0xF)
			}

			return String(bytesNoCopy: ptr, length: count*2, encoding: .utf8, freeWhenDone: true)!
		}
	}
}
