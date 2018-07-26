# Key Chain Share Test

### Reference

- https://www.raywenderlich.com/185370/basic-ios-security-keychain-hashing

### Step

#### 在apple developer裡要的事
1. Certificate -> Identifiers -> App Groups增加你要share的app group

2. 在你需要share key chain的app id 開啟App Groups加入剛剛新增的app group

#### 在專案裡要做的事

1. Target -> Capabilities -> Keychain Sharing 加入之前在App Groups加入的app grop

2. Info.plist加入一組key-value <br/>
Key: AppIdentifierPrefix <br/>
Value: $(AppIdentifierPrefix) <br/>

3. 到時二個app就會用相同的`$(AppIdentifierPrefix)com.share.group`來分享keychain了
