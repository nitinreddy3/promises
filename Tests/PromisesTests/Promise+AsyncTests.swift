// Copyright 2018 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import PromisesTestHelpers
import XCTest
@testable import Promises

class PromiseAsyncTests: XCTestCase {
  func testPromiseAsyncFulfill() {
    // Arrange & Act.
    let promise = Promise<Int> { fulfill, _ in
      fulfill(42)
    }

    // Assert.
    XCTAssert(waitForPromises(timeout: 10))
    XCTAssertEqual(promise.value, 42)
    XCTAssertNil(promise.error)
  }

  func testPromiseAsyncReject() {
    // Arrange & Act.
    let promise = Promise<Int> { _, reject in
      reject(Test.Error.code42)
    }

    // Assert.
    XCTAssert(waitForPromises(timeout: 10))
    XCTAssertTrue(promise.error == Test.Error.code42)
    XCTAssertNil(promise.value)
  }

  func testPromiseAsyncThrow() {
    // Arrange & Act.
    let promise = Promise<Int> { _, _ in
      throw Test.Error.code42
    }

    // Assert.
    XCTAssert(waitForPromises(timeout: 10))
    XCTAssertTrue(promise.error == Test.Error.code42)
    XCTAssertNil(promise.value)
  }

  func testPromiseAsyncNoDeallocUntilFulfilled() {
    // Arrange.
    weak var weakExtendedPromise1: Promise<Int>?
    weak var weakExtendedPromise2: Promise<Int>?

    // Act.
    autoreleasepool {
      XCTAssertNil(weakExtendedPromise1)
      XCTAssertNil(weakExtendedPromise2)
      let promise1 = Promise<Int> { fulfill, _ in
        fulfill(42)
      }
      let promise2 = Promise<Int> { fulfill, _ in
        fulfill(42)
      }
      weakExtendedPromise1 = promise1
      weakExtendedPromise2 = promise2
      XCTAssertNotNil(weakExtendedPromise1)
      XCTAssertNotNil(weakExtendedPromise2)
    }

    // Assert.
    XCTAssertNotNil(weakExtendedPromise1)
    XCTAssertNotNil(weakExtendedPromise2)
    XCTAssert(waitForPromises(timeout: 10))
    XCTAssertNil(weakExtendedPromise1)
    XCTAssertNil(weakExtendedPromise2)
  }
}
