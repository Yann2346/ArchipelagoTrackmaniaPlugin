class Items{
    int bronzeMedals; //24000
    int silverMedals; //24001
    int goldMedals;   //24002
    int authorMedals; //24003
    int skips;        //24004
    int discounts;    //24005
    int traps;        //24050
    int filler;       //24500

    int skipsUsed;
    int discountsUsed;

    int itemsRecieved;

    SaveData@ saveData;

    Items(SaveData@ saveData){
        bronzeMedals = 0;
        silverMedals = 0;
        goldMedals = 0;
        authorMedals = 0;
        skips = 0;
        discounts = 0;
        traps = 0;
        filler = 0;

        skipsUsed = 0;
        discountsUsed = 0;

        itemsRecieved = 0;

        @this.saveData = saveData;
    }

    Items(SaveData@ saveData, const Json::Value &in json){
        @this.saveData = saveData;
        try {
            bronzeMedals = json["bronzeMedals"];
            silverMedals = json["silverMedals"];
            goldMedals = json["goldMedals"];
            authorMedals = json["authorMedals"];
            skips = json["skips"];
            discounts = json["discounts"];
            traps = json["traps"];
            filler = json["filler"];
            skipsUsed = json["skipsUsed"];
            discountsUsed = json["discountsUsed"];
            itemsRecieved = json["itemsRecieved"];
        } catch {
            Log::Error("Error parsing Items"+ "\nReason: " + getExceptionInfo());
        }
    }

    int GetProgressionMedalCount(){
        float targetTimeSetting = saveData.settings.targetTimeSetting;
        if (targetTimeSetting < 1.0){
            return bronzeMedals;
        }else if (targetTimeSetting < 2.0){
            return silverMedals;
        }else if (targetTimeSetting < 3.0){
            return goldMedals;
        }else {
            return authorMedals;
        }
    }

    int GetPointCount(){
        float targetTimeSetting = saveData.settings.targetTimeSetting;
        bool bronzeMedalsDisabled = saveData.settings.bronzeMedalsDisabled;
        bool silverMedalsDisabled = saveData.settings.silverMedalsDisabled;
        bool goldMedalsDisabled = saveData.settings.goldMedalsDisabled;

        if (targetTimeSetting < 1.0){
            return bronzeMedals * 10;
        }
        else if (targetTimeSetting < 2.0){
            if (bronzeMedalsDisabled) {
                return silverMedals * 10;
            }
            else {
                int pointCount = silverMedals * 7 + bronzeMedals * 3;
                return pointCount;
            }
        }
        else if (targetTimeSetting < 3.0){
            if (bronzeMedalsDisabled){
                if (silverMedalsDisabled){
                    return goldMedals * 10;
                }
                int pointCount = goldMedals * 7 + silverMedals * 3;
                return pointCount
            }
            else if (silverMedalsDisabled){
                int pointCount = goldMedals * 7 + bronzeMedals * 3;
                return pointCount
            }
            else {
                int pointCount = goldMedals * 5 + silverMedals * 3 + bronzeMedals * 2;
                return pointCount;
            }
        }
        else {
            if (bronzeMedalsDisabled){
                if (silverMedalsDisabled){
                    if (goldMedalsDisabled){
                        return authorMedals * 10;
                    }
                    int pointCount = authorMedals * 7 + goldMedals * 3;
                    return pointCount
                }
                if (goldMedalsDisabled){
                    int pointCount = authorMedals * 7 + silverMedals * 3;
                    return pointCount
                }
                int pointCount = authorMedals * 5 + goldMedals * 3 + silverMedals * 2;
                return pointCount;
            }
            else if (silverMedalsDisabled){
                if (goldMedalsDisabled) {
                    int pointCount = authorMedals * 7 + bronzeMedals * 3;
                    return pointCount
                }
                int pointCount = authorMedals * 5 + goldMedals * 3 + bronzeMedals * 2;
                return pointCount;
            }
            else if (goldMedalsDisabled){
                int pointCount = authorMedals * 5 + silverMedals * 3 + bronzeMedals * 2;
                return pointCount;
            }
            else {
                int pointCount = authorMedals*5 + goldMedals*3 + silverMedals*1 + bronzeMedals*1;
                return pointCount;
            }
        }
    }

    int GetEqualizedPointCount(){
        float targetTimeSetting = saveData.settings.targetTimeSetting;
        bool bronzeMedalsDisabled = saveData.settings.bronzeMedalsDisabled;
        bool silverMedalsDisabled = saveData.settings.silverMedalsDisabled;
        bool goldMedalsDisabled = saveData.settings.goldMedalsDisabled;

        if (targetTimeSetting < 1.0){
            return bronzeMedals * 12;
        }
        else if (targetTimeSetting < 2.0){
            if (bronzeMedalsDisabled) {
                return silverMedals * 12;
            }
            else {
                int pointCount = silverMedals * 6 + bronzeMedals * 6;
                return pointCount;
            }
        }
        else if (targetTimeSetting < 3.0){
            if (bronzeMedalsDisabled){
                if (silverMedalsDisabled){
                    return goldMedals * 12;
                }
                int pointCount = goldMedals * 6 + silverMedals * 6;
                return pointCount
            }
            else if (silverMedalsDisabled){
                int pointCount = goldMedals * 6 + bronzeMedals * 6;
                return pointCount
            }
            else {
                int pointCount = goldMedals * 4 + silverMedals * 4 + bronzeMedals * 4;
                return pointCount;
            }
        }
        else {
            if (bronzeMedalsDisabled){
                if (silverMedalsDisabled){
                    if (goldMedalsDisabled){
                        return authorMedals * 10;
                    }
                    int pointCount = authorMedals * 6 + goldMedals * 6;
                    return pointCount
                }
                if (goldMedalsDisabled){
                    int pointCount = authorMedals * 6 + silverMedals * 6;
                    return pointCount
                }
                int pointCount = authorMedals * 4 + goldMedals * 4 + silverMedals * 4;
                return pointCount;
            }
            else if (silverMedalsDisabled){
                if (goldMedalsDisabled) {
                    int pointCount = authorMedals * 6 + bronzeMedals * 6;
                    return pointCount
                }
                int pointCount = authorMedals * 4 + goldMedals * 4 + bronzeMedals * 4;
                return pointCount;
            }
            else if (goldMedalsDisabled){
                int pointCount = authorMedals * 4 + silverMedals * 4 + bronzeMedals * 4;
                return pointCount;
            }
            else {
                int pointCount = authorMedals*3 + goldMedals*3 + silverMedals*3 + bronzeMedals*3;
                return pointCount;
            }
        }
    }

    void AddItem (int itemID, int itemCount = 1) {
        switch (itemID){
            case ItemTypes::BronzeMedal:
                bronzeMedals += itemCount;
                break;
            case ItemTypes::SilverMedal:
                silverMedals += itemCount;
                break;
            case ItemTypes::GoldMedal:
                goldMedals += itemCount;
                break;
            case ItemTypes::AuthorMedal:
                authorMedals += itemCount;
                break;
            case ItemTypes::Skip:
                skips += itemCount;
                break;
            case ItemTypes::Discount:
                discounts += itemCount;
                break;
            // case ItemTypes::Filler:
            //     filler += itemCount;
            //     break;
            default:
                if (itemID < int(ItemTypes::Filler)){
                    traps += itemCount;
                }else{
                    filler += itemCount;
                }
                break;
        }
        itemsRecieved += itemCount;
    }

    void Reset(){
        bronzeMedals = 0;
        silverMedals = 0;
        goldMedals = 0;
        authorMedals = 0;
        skips = 0;
        discounts = 0;
        traps = 0;
        filler = 0;
        itemsRecieved = 0;
    }

    Json::Value ToJson(){
        Json::Value json = Json::Object();
        try {
            json["bronzeMedals"] = bronzeMedals;
            json["silverMedals"] = silverMedals;
            json["goldMedals"] = goldMedals;
            json["authorMedals"] = authorMedals;
            json["skips"] = skips;
            json["discounts"] = discounts;
            json["traps"] = traps;
            json["filler"] = filler;
            json["skipsUsed"] = skipsUsed;
            json["discountsUsed"] = discountsUsed;
            json["itemsRecieved"] = itemsRecieved;
        } catch {
            Log::Error("Error converting Items to JSON");
        }
        return json;
    }
}