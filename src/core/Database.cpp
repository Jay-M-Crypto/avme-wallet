// Copyright (c) 2020-2021 AVME Developers
// Distributed under the MIT/X11 software license, see the accompanying
// file LICENSE or http://www.opensource.org/licenses/mit-license.php.
#include "Database.h"

// ======================================================================
// TOKEN DATABASE FUNCTIONS
// ======================================================================

bool Database::openTokenDB() {
  std::string path = Utils::walletFolderPath.string() + "/wallet/c-avax/tokens";
  if (!exists(path)) { create_directories(path); }
  this->tokenStatus = leveldb::DB::Open(this->tokenOpts, path, &this->tokenDB);
  std::vector<std::string> tokenJsonList = this->getAllTokenDBValues();
  if (tokenJsonList.size() == 0) {
    // AVME is hardcoded at database creation
    json avme;
    avme["address"] = Pangolin::contracts["AVME"];
    avme["symbol"] = "AVME";
    avme["name"] = "AVME";
    avme["decimals"] = 18;
    avme["avaxPairContract"] = Pangolin::contracts["AVAX-AVME"];
    this->putTokenDBValue(Pangolin::contracts["AVME"], avme.dump());
  }
  return this->tokenStatus.ok();
}

std::string Database::getTokenDBStatus() {
  return this->tokenStatus.ToString();
}

void Database::closeTokenDB() {
  delete this->tokenDB;
  this->tokenDB = NULL;
}

bool Database::isTokenDBOpen() {
  return (this->tokenDB != NULL);
}

bool Database::tokenDBKeyExists(std::string key) {
  leveldb::Iterator* it = this->tokenDB->NewIterator(leveldb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    if (it->key().ToString() == key) return true;
  }
  return false;
}

std::string Database::getTokenDBValue(std::string key) {
  this->tokenStatus = this->tokenDB->Get(leveldb::ReadOptions(), key, &this->tokenValue);
  return (this->tokenStatus.ok()) ? this->tokenValue : this->tokenStatus.ToString();
}

bool Database::putTokenDBValue(std::string key, std::string value) {
  this->tokenStatus = this->tokenDB->Put(leveldb::WriteOptions(), key, value);
  return this->tokenStatus.ok();
}

bool Database::deleteTokenDBValue(std::string key) {
  this->tokenStatus = this->tokenDB->Delete(leveldb::WriteOptions(), key);
  return this->tokenStatus.ok();
}

std::vector<std::string> Database::getAllTokenDBValues() {
  std::vector<std::string> ret;
  leveldb::Iterator* it = this->tokenDB->NewIterator(leveldb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    ret.push_back(it->value().ToString());
  }
  delete it;
  return ret;
}

// ======================================================================
// TX HISTORY DATABASE FUNCTIONS
// ======================================================================

bool Database::openHistoryDB(std::string address) {
  std::string path = Utils::walletFolderPath.string()
    + "/wallet/c-avax/accounts/transactions/" + address;
  // Automatically delete old history in JSON format if it exists
  boost::filesystem::path oldPath = path;
  if (boost::filesystem::is_regular_file(oldPath)) { boost::filesystem::remove(oldPath); }
  if (!exists(path)) { create_directories(path); }
  this->historyStatus = leveldb::DB::Open(this->historyOpts, path, &this->historyDB);
  return this->historyStatus.ok();
}

std::string Database::getHistoryDBStatus() {
  return this->historyStatus.ToString();
}

void Database::closeHistoryDB() {
  delete this->historyDB;
  this->historyDB = NULL;
}

bool Database::isHistoryDBOpen() {
  return (this->historyDB != NULL);
}

bool Database::historyDBKeyExists(std::string key) {
  leveldb::Iterator* it = this->historyDB->NewIterator(leveldb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    if (it->key().ToString() == key) return true;
  }
  return false;
}

std::string Database::getHistoryDBValue(std::string key) {
  this->historyStatus = this->tokenDB->Get(leveldb::ReadOptions(), key, &this->historyValue);
  return (this->historyStatus.ok()) ? this->historyValue : this->historyStatus.ToString();
}

bool Database::putHistoryDBValue(std::string key, std::string value) {
  this->historyStatus = this->historyDB->Put(leveldb::WriteOptions(), key, value);
  return this->historyStatus.ok();
}

bool Database::deleteHistoryDBValue(std::string key) {
  this->historyStatus = this->historyDB->Delete(leveldb::WriteOptions(), key);
  return this->historyStatus.ok();
}

std::vector<std::string> Database::getAllHistoryDBValues() {
  std::vector<std::string> ret;
  leveldb::Iterator* it = this->historyDB->NewIterator(leveldb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    ret.push_back(it->value().ToString());
  }
  delete it;
  return ret;
}

// ======================================================================
// LEDGER DATABASE FUNCTIONS
// ======================================================================

bool Database::openLedgerDB() {
  std::string path = Utils::walletFolderPath.string() + "/wallet/c-avax/accounts/ledger";
  if (!exists(path)) { create_directories(path); }
  this->ledgerStatus = leveldb::DB::Open(this->ledgerOpts, path, &this->ledgerDB);
  return this->ledgerStatus.ok();
}

std::string Database::getLedgerDBStatus() {
  return this->ledgerStatus.ToString();
}

void Database::closeLedgerDB() {
  delete this->ledgerDB;
  this->ledgerDB = NULL;
}

bool Database::isLedgerDBOpen() {
  return (this->ledgerDB != NULL);
}

bool Database::ledgerDBKeyExists(std::string key) {
  leveldb::Iterator* it = this->ledgerDB->NewIterator(leveldb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    if (it->key().ToString() == key) return true;
  }
  return false;
}

std::string Database::getLedgerDBValue(std::string key) {
  this->ledgerStatus = this->ledgerDB->Get(leveldb::ReadOptions(), key, &this->ledgerValue);
  return (this->ledgerStatus.ok()) ? this->ledgerValue : this->ledgerStatus.ToString();
}

bool Database::putLedgerDBValue(std::string key, std::string value) {
  this->ledgerStatus = this->ledgerDB->Put(leveldb::WriteOptions(), key, value);
  return this->ledgerStatus.ok();
}

bool Database::deleteLedgerDBValue(std::string key) {
  this->ledgerStatus = this->ledgerDB->Delete(leveldb::WriteOptions(), key);
  return this->ledgerStatus.ok();
}

std::vector<std::string> Database::getAllLedgerDBValues() {
  std::vector<std::string> ret;
  leveldb::Iterator* it = this->ledgerDB->NewIterator(leveldb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    ret.push_back(it->value().ToString());
  }
  delete it;
  return ret;
}

// ======================================================================
// DAPP DATABASE FUNCTIONS
// ======================================================================

bool Database::openAppDB() {
  std::string path = Utils::walletFolderPath.string() + "/wallet/c-avax/appdb";
  if (!exists(path)) { create_directories(path); }
  this->appStatus = leveldb::DB::Open(this->appOpts, path, &this->appDB);
  return this->appStatus.ok();
}

std::string Database::getAppDBStatus() {
  return this->appStatus.ToString();
}

void Database::closeAppDB() {
  delete this->appDB;
  this->appDB = NULL;
}

bool Database::isAppDBOpen() {
  return (this->appDB != NULL);
}

bool Database::appDBKeyExists(std::string key) {
  leveldb::Iterator* it = this->appDB->NewIterator(leveldb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    if (it->key().ToString() == key) return true;
  }
  return false;
}

std::string Database::getAppDBValue(std::string key) {
  this->appStatus = this->appDB->Get(leveldb::ReadOptions(), key, &this->appValue);
  return (this->appStatus.ok()) ? this->appValue : this->appStatus.ToString();
}

bool Database::putAppDBValue(std::string key, std::string value) {
  this->appStatus = this->appDB->Put(leveldb::WriteOptions(), key, value);
  return this->appStatus.ok();
}

bool Database::deleteAppDBValue(std::string key) {
  this->appStatus = this->appDB->Delete(leveldb::WriteOptions(), key);
  return this->appStatus.ok();
}

std::vector<std::string> Database::getAllAppDBValues() {
  std::vector<std::string> ret;
  leveldb::Iterator* it = this->appDB->NewIterator(leveldb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    ret.push_back(it->value().ToString());
  }
  delete it;
  return ret;
}

// ======================================================================
// CONTACTS DATABASE FUNCTIONS
// ======================================================================

bool Database::openAddressDB() {
  std::string path = Utils::walletFolderPath.string() + "/wallet/c-avax/contacts";
  if (!exists(path)) { create_directories(path); }
  this->addressStatus = leveldb::DB::Open(this->addressOpts, path, &this->addressDB);
  return this->addressStatus.ok();
}

std::string Database::getAddressDBStatus() {
  return this->addressStatus.ToString();
}

void Database::closeAddressDB() {
  delete this->addressDB;
  this->addressDB = NULL;
}

bool Database::isAddressDBOpen() {
  return (this->addressDB != NULL);
}

bool Database::addressDBKeyExists(std::string key) {
  leveldb::Iterator* it = this->addressDB->NewIterator(leveldb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    if (it->key().ToString() == key) return true;
  }
  return false;
}

std::string Database::getAddressDBValue(std::string key) {
  this->addressStatus = this->addressDB->Get(leveldb::ReadOptions(), key, &this->addressValue);
  return (this->addressStatus.ok()) ? this->addressValue : this->addressStatus.ToString();
}

bool Database::putAddressDBValue(std::string key, std::string value) {
  this->addressStatus = this->addressDB->Put(leveldb::WriteOptions(), key, value);
  return this->addressStatus.ok();
}

bool Database::deleteAddressDBValue(std::string key) {
  this->addressStatus = this->addressDB->Delete(leveldb::WriteOptions(), key);
  return this->addressStatus.ok();
}

std::vector<std::string> Database::getAllAddressDBValues() {
  std::vector<std::string> ret;
  leveldb::Iterator* it = this->addressDB->NewIterator(leveldb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    ret.push_back(it->value().ToString());
  }
  delete it;
  return ret;
}

// ======================================================================
// SETTINGS DATABASE FUNCTIONS
// ======================================================================

bool Database::openConfigDB() {
  std::string path = Utils::walletFolderPath.string() + "/config";
  if (!exists(path)) { create_directories(path); }
  this->configStatus = leveldb::DB::Open(this->configOpts, path, &this->configDB);
  return this->configStatus.ok();
}

std::string Database::getConfigDBStatus() {
  return this->configStatus.ToString();
}

void Database::closeConfigDB() {
  delete this->configDB;
  this->configDB = NULL;
}

bool Database::isConfigDBOpen() {
  return (this->configDB != NULL);
}

bool Database::configDBKeyExists(std::string key) {
  leveldb::Iterator* it = this->configDB->NewIterator(leveldb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    if (it->key().ToString() == key) return true;
  }
  return false;
}

std::string Database::getConfigDBValue(std::string key) {
  this->configStatus = this->configDB->Get(leveldb::ReadOptions(), key, &this->configValue);
  return (this->configStatus.ok()) ? this->configValue : this->configStatus.ToString();
}

bool Database::putConfigDBValue(std::string key, std::string value) {
  this->configStatus = this->configDB->Put(leveldb::WriteOptions(), key, value);
  return this->configStatus.ok();
}

bool Database::deleteConfigDBValue(std::string key) {
  this->configStatus = this->configDB->Delete(leveldb::WriteOptions(), key);
  return this->configStatus.ok();
}

std::vector<std::string> Database::getAllConfigDBValues() {
  std::vector<std::string> ret;
  leveldb::Iterator* it = this->configDB->NewIterator(leveldb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    ret.push_back(it->value().ToString());
  }
  delete it;
  return ret;
}
