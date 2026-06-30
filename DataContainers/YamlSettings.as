class YamlSettings{
    float targetTimeSetting;
    int progressionSystem;
    float discountAmount;
    int seriesCount;
    bool bronzeDisabled;
    bool silverDisabled;
    bool goldDisabled;
    bool authorDisabled;
    bool goldMedalsDisabled;
    bool silverMedalsDisabled;
    bool bronzeMedalsDisabled;

     

    YamlSettings() {
        targetTimeSetting = 0.0;
        seriesCount = 0;
    }

    YamlSettings(const Json::Value &in json, bool isSlot = false) {
        try {
            if (isSlot){
                ReadSlotData(json);            
            }else{
                ReadJsonV1_2(json);
            }
            if (progressionSystem == 1 || progressionSystem == 2){
                UpdateChecksToDo();
            }
        } catch {
            Log::Warn("Error parsing YamlSettings"+ "\nReason: " + getExceptionInfo());
        }
    }

    bool DoingBronze(){
        return !bronzeDisabled;
    }

    bool DoingSilver(){
        return targetTimeSetting >= 1 && !silverDisabled;
    }

    bool DoingGold(){
        return targetTimeSetting >= 2 && !goldDisabled;
    }

    bool DoingAuthor(){
        return targetTimeSetting >= 3 && !authorDisabled;
    }

    void UpdateChecksToDo(){
        int medalsToDo = 0;
        if (!bronzeMedalsDisabled || targetTimeSetting < 1){
            medalsToDo += 1;
        }
        if ((targetTimeSetting >= 1 && !silverMedalsDisabled) || (2 > targetTimeSetting >= 1)){
            medalsToDo += 1;
        }
        if ((targetTimeSetting >= 2 && !goldMedalsDisabled) || (3 > targetTimeSetting >= 2)){
            medalsToDo += 1;
        }
        if (targetTimeSetting >= 3) {
            medalsToDo += 1;
        }

        int checksToDo = 0;
        if (DoingBronze()){
            checksToDo += 1;
        }
        if (DoingSilver()){
            checksToDo += 1;
        }
        if (DoingGold()){
            checksToDo += 1;
        }
        if (DoingAuthor()){
            checksToDo += 1;
        }

        if (checksToDo >= medalsToDo){
            return;
        }
        else {
            if (!DoingBronze()){
                bronzeDisabled = False;
                checksToDo += 1;
            }
            if (checksToDo < medalsToDo && !DoingSilver()){
                silverDisabled = False;
                checksToDo += 1;
            }
            if (checksToDo < medalsToDo && !DoingGold()){
                goldDisabled = False;
                checksToDo += 1;
            }
            if (checksToDo < medalsToDo && !DoingAuthor()){
                authorDisabled = False;
            }
            return;
        }
    }

    Json::Value ToJson() {
        Json::Value json = Json::Object();
        try {
            json["targetTimeSetting"] = targetTimeSetting;
            json["progressionSystem"] = progressionSystem;
            json["discountAmount"] = discountAmount;
            json["seriesCount"] = seriesCount;
            json["bronzeDisabled"] = bronzeDisabled;
            json["silverDisabled"] = silverDisabled;
            json["goldDisabled"] = goldDisabled;
            json["authorDisabled"] = authorDisabled;
            json["goldMedalsDisabled"] = goldMedalsDisabled;
            json["silverMedalsDisabled"] = silverMedalsDisabled;
            json["bronzeMedalsDisabled"] = bronzeMedalsDisabled;
        } catch {
            Log::Error("Error converting Yaml Settings to JSON");
        }
        return json;
    }

    void ReadSlotData(const Json::Value &in json){
        seriesCount = json["SeriesNumber"];
        targetTimeSetting = json["TargetTimeSetting"];
        progressionSystem = json["ProgressionSystem"];
        discountAmount = json.Get("DiscountAmount",0.015);
        bronzeDisabled = JsonGetAsBool(json, "DisableBronze");
        silverDisabled = JsonGetAsBool(json, "DisableSilver");
        goldDisabled = JsonGetAsBool(json, "DisableGold");
        authorDisabled = JsonGetAsBool(json, "DisableAuthor");
        goldMedalsDisabled = JsonGetAsBool(json, "DisableGoldMedals");
        silverMedalsDisabled = JsonGetAsBool(json, "DisableSilverMedals");
        bronzeMedalsDisabled = JsonGetAsBool(json, "DisableBronzeMedals");
    }

    void ReadJsonV1_2(const Json::Value &in json){
        targetTimeSetting = json["targetTimeSetting"];
        progressionSystem = json["progressionSystem"];
        discountAmount = json["discountAmount"];
        seriesCount = json["seriesCount"];
        bronzeDisabled = JsonGetAsBool(json, "bronzeDisabled");
        silverDisabled = JsonGetAsBool(json, "silverDisabled");
        goldDisabled = JsonGetAsBool(json, "goldDisabled");
        authorDisabled = JsonGetAsBool(json, "authorDisabled");
        goldMedalsDisabled = JsonGetAsBool(json, "DisableGoldMedals");
        silverMedalsDisabled = JsonGetAsBool(json, "DisableSilverMedals");
        bronzeMedalsDisabled = JsonGetAsBool(json, "DisableBronzeMedals");
    }
}