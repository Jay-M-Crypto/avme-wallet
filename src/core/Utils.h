// Copyright (c) 2020-2021 AVME Developers
// Distributed under the MIT/X11 software license, see the accompanying
// file LICENSE or http://www.opensource.org/licenses/mit-license.php.
#ifndef UTILS_H
#define UTILS_H

#include <chrono>
#include <string>

#include <boost/chrono.hpp>
#include <boost/lexical_cast.hpp>
#include <qrencode.h>

#include <openssl/rand.h>

#include <lib/devcore/CommonIO.h>
#include <lib/devcore/FileSystem.h>
#include <lib/devcore/SHA3.h>
#include <lib/ethcore/KeyManager.h>
#include <lib/ethcore/TransactionBase.h>

using namespace dev;  // u256
using namespace dev::eth; // TransactionBase

/**
 * Conversion template for usage with boost::lexical_cast.
 * e.g. boost::lexical_cast<HexTo<int>>(var);
 */
template <typename ElemT>
struct HexTo {
  ElemT value;
  operator ElemT() const { return value; }
  friend std::istream& operator>>(std::istream& in, HexTo& out) {
    in >> std::hex >> out.value;
    return in;
  }
};

// Struct for a single ARC20 Token.
typedef struct ARC20Token {
  // Those are stored in JSON
  std::string address;
  std::string symbol;
  std::string name;
  int decimals;
  std::string avaxPairContract;
  // Those are NOT stored in JSON
  bigfloat reserve;
  bigfloat avaxReserve;
} ARC20Token;

// Struct for a single Transaction.
typedef struct TxData {
  std::string txlink;
  std::string operation;
  std::string hex;
  std::string type;
  std::string code;
  std::string to;
  std::string from;
  std::string data;
  std::string creates;
  std::string value;
  std::string nonce;
  std::string gas;
  std::string price;
  std::string hash;
  std::string v;
  std::string r;
  std::string s;
  std::string humanDate;
  uint64_t unixDate;
  bool confirmed;
  bool invalid;
} TxData;

/**
 * Namespace for general utility functions.
 */
namespace Utils {
  extern boost::filesystem::path walletFolderPath; // Top folder where the Wallet is.
  extern std::mutex debugFileLock;  // Mutex for the deug log file.
  u256 MAX_U256_VALUE();  // Maximum 256-bit unsigned int value (for error handling).

  /**
   * Write information to the debug log file.
   */
  void logToDebug(std::string debug);

  /**
   * Generate a random 16-byte Hex to be used as a tag/ID.
   */
  std::string randomHexBytes();

  /**
   * Decode a raw transaction in Hex.
   * Returns a struct with the transaction's data.
   */
  TxData decodeRawTransaction(std::string rawTxHex);

  /**
   * Convert a full Wei amount to a fixed point amount and vice-versa,
   * in the given amount of digits/decimals.
   * BTC has 8 decimals but is considered a full integer in code, so 1.0 BTC
   * actually means 100000000 satoshis.
   * Likewise with ETH, AVAX, etc., which have 18 digits, so 1.0 ETH/AVAX
   * actually means 1000000000000000000 Wei.
   * This also applies to their respective tokens.
   * Operations are actually done with full amounts, but to make those
   * operations more human-friendly, we show to and collect from the user
   * fixed point values, then convert those to full amounts and back.
   * Returns the fixed point and full amounts, respectively.
   */
  std::string weiToFixedPoint(std::string amount, size_t digits);
  std::string fixedPointToWei(std::string amount, int decimals);

  /**
   * Converts input to the correspondent 32-byte hex value (with padding).
   * uintToHex should work with uint<M>, bytes and bool.
   * addressToHex is solely for address.
   * Returns the hex string.
   */
  std::string uintToHex(std::string input);
  std::string addressToHex(std::string input);
};

#endif  // UTILS_H
