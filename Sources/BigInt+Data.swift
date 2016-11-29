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
	/// Representation as Data
	public var data: Data {
		let n = Int(mpz._mp_size)
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
	/// - Parameter data: the data to convert to a BigInt
	public convenience init(data: Data) {
		self.init()
		let n = data.count
		guard n > 0 else { return }
		let lbytes = Int(GMP_LIMB_BITS / 8)
		let m = mp_size_t((n + (lbytes-1)) / lbytes)
		let limbs = __gmpz_limbs_write(&mpz, m)!
		data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) -> Void in
			var p = ptr
			let r = n % lbytes
			let k = r == 0 ? lbytes : r
			for j in (0..<k).reversed() {
				limbs[m-1] += mp_limb_t(p.pointee) << mp_limb_t(j*8)
				p += 1
			}
			guard m > 1 else { return }
			for i in (0..<(m-1)).reversed() {
				for j in (0..<lbytes).reversed() {
					limbs[i] += mp_limb_t(p.pointee) << mp_limb_t(j*8)
					p += 1
				}
			}
		}
		__gmpz_limbs_finish(&mpz, m)
	}
}
