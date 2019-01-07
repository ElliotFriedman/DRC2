
/*
	we will implement 3 standard functions

	- create asset
	- send asset
	- withdraw all funds (only owner is allowed to do this)

*/

Function Initialize() Uint64
1 IF LOAD("init") == 0 THEN GOTO 3
2 RETURN 1
3 STORE("init", 1) //you can only call the constructor once
4 STORE("owner", ADDRESS_RAW(SIGNER())) //make sure to keep track of the owner
5 STORE(0, LOAD("owner")) //owner owns asset 0
6 STORE("ASSET_NUM", 0) //store the current asset that is available
7 RETURN 0
End Function

Function createAsset() Uint64
40 dim currAsset as Uint64 //create currasset in Memory
50 LET currAsset = LOAD("ASSET_NUM") + 1 //grab the current asset number
60 STORE("ASSET_NUM", currAsset) //increment the counter globally so that two people don't own the same asset which would override first owner
65 STORE(currAsset, ADDRESS_RAW(SIGNER())) //map the number to the address of who owns it
70 RETURN 0
End Function

Function withdrawAll(amt Uint64) Uint64
10 IF LOAD("owner") ==  ADDRESS_RAW(SIGNER()) THEN GOTO 12 //make sure that the owner is the person calling
11 RETURN 1
12 SEND_DERO_TO_ADDRESS(SIGNER(), amt) //send money to the owner, probably should not be in raw format and in regular hex encoded output like we are using
13 RETURN 0
End Function

Function sendAsset(to String, assetID Uint64) Uint64
14 IF LOAD(assetID) ==  ADDRESS_RAW(SIGNER()) THEN GOTO 16 //will panic if assetID does not exist so we don't need to worry about checking this
15 RETURN 1
16 IF IS_ADDRESS_VALID(to) == 1 THEN GOTO 18 //don't want to send asset to a non-existent person or a mis-typed address so check validity
17 RETURN 1
18 STORE(assetID,  ADDRESS_RAW(to)) //give the asset to the person the sender requested
19 RETURN 0
End Function

Function getAddress() String
101 RETURN SCID()
End Function

