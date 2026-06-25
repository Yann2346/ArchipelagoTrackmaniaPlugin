UI::Font@ fontHeader;
UI::Font@ fontHeaderSub;
UI::Font@ fontTime;
int NvgFont;

UI::Texture@ bronzeTex;
UI::Texture@ silverTex;
UI::Texture@ goldTex;
UI::Texture@ authorTex;
UI::Texture@ archipelagoTex;

Audio::Sample@ victoryClip;

//jeepers
nvg::Texture@ bronzeTexNVG;
nvg::Texture@ silverTexNVG;
nvg::Texture@ goldTexNVG;
nvg::Texture@ authorTexNVG;
nvg::Texture@ archipelagoTexNVG;

#if TMNEXT
nvg::Texture@ bronzeTexNVGSmol;
nvg::Texture@ silverTexNVGSmol;
nvg::Texture@ goldTexNVGSmol;
nvg::Texture@ authorTexNVGSmol;
nvg::Texture@ archipelagoTexNVGSmol;
nvg::Texture@ shadowTexNVG;
nvg::Texture@ bronzeTexNVGMed;
nvg::Texture@ silverTexNVGMed;
nvg::Texture@ goldTexNVGMed;
nvg::Texture@ authorTexNVGMed;
nvg::Texture@ archipelagoTexNVGMed;

#elif MP4
nvg::Texture@ bronzeTexNVGBowTie;
nvg::Texture@ silverTexNVGBowTie;
nvg::Texture@ goldTexNVGBowTie;
nvg::Texture@ authorTexNVGBowTie;
nvg::Texture@ archipelagoTexNVGBowTie;
nvg::Texture@ bronzeTexNVGBottom;
nvg::Texture@ silverTexNVGBottom;
nvg::Texture@ goldTexNVGBottom;
nvg::Texture@ authorTexNVGBottom;
nvg::Texture@ archipelagoTexNVGBottom;
#endif

void RenderLoadingError(){

    //UI::SetNextWindowSize(600, 400, UI::Cond::Always);
    UI::PushStyleVar(UI::StyleVar::WindowTitleAlign, vec2(.5, .5));
    UI::PushStyleVar(UI::StyleVar::WindowPadding, vec2(12, 12));
    UI::PushStyleVar(UI::StyleVar::WindowRounding, 16.0);
    UI::PushStyleVar(UI::StyleVar::FrameRounding, 8.0);
    int flags = UI::WindowFlags::NoCollapse | UI::WindowFlags::NoDocking | UI::WindowFlags::AlwaysAutoResize;
    if (UI::Begin("Archipelago - Loading", isOpen, flags)){
        
        UI::Text("Assets not loaded :(");
        UI::Text("Please wait or try reloading the plugin.");
        UI::End();
        UI::PopStyleVar(4);
    }
}

void RenderInventory(){
    UI::Text("Progression Medals: " + data.items.GetProgressionMedalCount() + "/"+(data.victoryRequirement));
    UI::Text("Inventory: ");
    UI::BeginTable("Inventory", 5);
    UI::TableNextColumn();
    UI::Text("Bronzes: " + data.items.bronzeMedals);
    UI::TableNextColumn();
    UI::Text("Silvers: " + data.items.silverMedals);
    UI::TableNextColumn();
    UI::Text("Golds: " + data.items.goldMedals);
    UI::TableNextColumn();
    UI::Text("Authors: " + data.items.authorMedals);
    UI::TableNextColumn();
    UI::Text("Skips: " + (data.items.skips-data.items.skipsUsed)+"/"+data.items.skips);
    UI::EndTable();
}

void RenderMedalProgress(UI::Texture@ tex, float sizeMedal, int count, int total){
    float texSize = sizeMedal;
    UI::Image(tex,vec2(texSize,texSize));
    UI::SameLine();
    UI::PushFont(fontHeaderSub);
    MoveCursor(vec2(0.0,texSize*0.5-11));
    UI::Text(""+count+"/"+total);
    UI::PopFont();
}

void RenderMedalPossession(array<UI::Texture@> textures, float sizeMedal, array<int> medalCounts){
    float texSize = sizeMedal;
    for (uint i = 0; i < textures.Length; i++){
        UI::Image(textures[i],vec2(texSize,texSize));
        UI::SameLine();
        UI::PushFont(fontHeaderSub);
        MoveCursor(vec2(0.0,texSize*0.5-11));
        UI::Text(""+medalCounts[i]);
        UI::PopFont();
        if (i+1 < textures.Length){
            MoveCursor(vec2(0.0,(-1)*(texSize*0.5-11)));
            UI::SameLine();
        }
    }
}

void RenderScore(int score, int pointRequirement){
    UI::PushFont(fontHeaderSub);
    UI::Text(""+"Score : "+score+"/"+pointRequirement);
    UI::PopFont();
}

void RenderProgression(uint nextSeries, vec2 viewSize, string menu){
    int sizeMedal = 60;
    if (data.settings.progressionSystem == 0){
        int count = data.items.GetProgressionMedalCount();
        int total = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement : data.victoryRequirement;
        float medalOffset = (viewSize.x/2)-((sizeMedal+UI::MeasureString(""+count+"/"+total,fontHeaderSub).x)/2+16*UI::GetScale());
        MoveCursor(vec2(medalOffset,-15.0));
        RenderMedalProgress(GetProgressionTex(),sizeMedal,count,total);
        MoveCursor(vec2(-medalOffset,-15.0));
    }

    float targetTimeSetting = data.settings.targetTimeSetting;

    bool bronzeMedalsDisabled = data.settings.bronzeMedalsDisabled;
    bool silverMedalsDisabled = data.settings.silverMedalsDisabled;
    bool goldMedalsDisabled = data.settings.goldMedalsDisabled;

    if (data.settings.progressionSystem == 1){
        if (targetTimeSetting < 1.0){
            int count = data.items.GetProgressionMedalCount();
            int total = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement : data.victoryRequirement;
            float medalOffset = (viewSize.x/2)-((sizeMedal+UI::MeasureString(""+count+"/"+total,fontHeaderSub).x)/2+16*UI::GetScale());
            MoveCursor(vec2(medalOffset,-15.0));
            RenderMedalProgress(GetProgressionTex(),sizeMedal,count,total);
            MoveCursor(vec2(-medalOffset,-15.0));
        }
    
        else if (targetTimeSetting < 2.0){
            if (bronzeMedalsDisabled){
                int count = data.items.GetProgressionMedalCount();
                int total = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement : data.victoryRequirement;
                float medalOffset = (viewSize.x/2)-((sizeMedal+UI::MeasureString(""+count+"/"+total,fontHeaderSub).x)/2+16*UI::GetScale());
                MoveCursor(vec2(medalOffset,-15.0));
                RenderMedalProgress(GetProgressionTex(),sizeMedal,count,total);
                MoveCursor(vec2(-medalOffset,-15.0));
            }
            else{
                sizeMedal = (menu == "In map") ? 45 : 60;

                int countBronze = data.items.bronzeMedals;
                int countSilver = data.items.GetProgressionMedalCount();

                int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 12 : data.victoryRequirement * 12;
                int score = data.items.GetEqualizedPointCount();

                float medalOffset = (viewSize.x/2)-((sizeMedal*2 + UI::MeasureString(""+countBronze+" "+countSilver,fontHeaderSub).x)/2+16*UI::GetScale());
                array<UI::Texture@> textures = {bronzeTex, silverTex};
                array<int> medalCounts = {countBronze, countSilver};
                MoveCursor(vec2(medalOffset,-15.0));
                RenderMedalPossession(textures, sizeMedal, medalCounts);
                MoveCursor(vec2(-medalOffset,-15.0));

                float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                UI::NewLine();
                UI::NewLine();
                MoveCursor(vec2(scoreOffset,-15.0));
                RenderScore(score, pointRequirement);
                MoveCursor(vec2(-scoreOffset,-15.0));
            }
        }
        else if (targetTimeSetting < 3.0){
            if (bronzeMedalsDisabled){
                if (silverMedalsDisabled){
                    int count = data.items.GetProgressionMedalCount();
                    int total = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement : data.victoryRequirement;
                    float medalOffset = (viewSize.x/2)-((sizeMedal+UI::MeasureString(""+count+"/"+total,fontHeaderSub).x)/2+16*UI::GetScale());
                    MoveCursor(vec2(medalOffset,-15.0));
                    RenderMedalProgress(GetProgressionTex(),sizeMedal,count,total);
                    MoveCursor(vec2(-medalOffset,-15.0));
                }
                else{
                    sizeMedal = (menu == "In map") ? 45 : 60;

                    int countSilver = data.items.silverMedals;
                    int countGold = data.items.GetProgressionMedalCount();

                    int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 12 : data.victoryRequirement * 12;
                    int score = data.items.GetEqualizedPointCount();

                    float medalOffset = (viewSize.x/2)-((sizeMedal*2 + UI::MeasureString(""+countSilver+" "+countGold,fontHeaderSub).x)/2+16*UI::GetScale());
                    array<UI::Texture@> textures = {silverTex, goldTex};
                    array<int> medalCounts = {countSilver, countGold};
                    MoveCursor(vec2(medalOffset,-15.0));
                    RenderMedalPossession(textures, sizeMedal, medalCounts);
                    MoveCursor(vec2(-medalOffset,-15.0));

                    float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                    UI::NewLine();
                    UI::NewLine();
                    MoveCursor(vec2(scoreOffset,-15.0));
                    RenderScore(score, pointRequirement);
                    MoveCursor(vec2(-scoreOffset,-15.0));
                }
            }
            else if (silverMedalsDisabled){
                sizeMedal = (menu == "In map") ? 45 : 60;

                int countBronze = data.items.bronzeMedals;
                int countGold = data.items.GetProgressionMedalCount();

                int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 12 : data.victoryRequirement * 12;
                int score = data.items.GetEqualizedPointCount();

                float medalOffset = (viewSize.x/2)-((sizeMedal*2 + UI::MeasureString(""+countBronze+" "+countGold,fontHeaderSub).x)/2+16*UI::GetScale());
                array<UI::Texture@> textures = {bronzeTex, goldTex};
                array<int> medalCounts = {countBronze, countGold};
                MoveCursor(vec2(medalOffset,-15.0));
                RenderMedalPossession(textures, sizeMedal, medalCounts);
                MoveCursor(vec2(-medalOffset,-15.0));

                float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                UI::NewLine();
                UI::NewLine();
                MoveCursor(vec2(scoreOffset,-15.0));
                RenderScore(score, pointRequirement);
                MoveCursor(vec2(-scoreOffset,-15.0));
            }
            else{
                sizeMedal = (menu == "In map") ? 25 : 60;

                int countBronze = data.items.bronzeMedals;
                int countSilver = data.items.silverMedals;
                int countGold = data.items.GetProgressionMedalCount();

                int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 12 : data.victoryRequirement * 12;
                int score = data.items.GetEqualizedPointCount();

                float medalOffset = (viewSize.x/2)-((sizeMedal*3 + UI::MeasureString(""+countBronze+" "+countSilver+" "+countGold,fontHeaderSub).x)/2+16*UI::GetScale());
                array<UI::Texture@> textures = {bronzeTex, silverTex, goldTex};
                array<int> medalCounts = {countBronze, countSilver, countGold};
                MoveCursor(vec2(medalOffset,-15.0));
                RenderMedalPossession(textures, sizeMedal, medalCounts);
                MoveCursor(vec2(-medalOffset,-15.0));

                float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                UI::NewLine();
                UI::NewLine();
                MoveCursor(vec2(scoreOffset,-15.0));
                RenderScore(score, pointRequirement);
                MoveCursor(vec2(-scoreOffset,-15.0));
            }
        }
        else{
            if (bronzeMedalsDisabled){
                if (silverMedalsDisabled){
                    if (goldMedalsDisabled){
                        int count = data.items.GetProgressionMedalCount();
                        int total = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement : data.victoryRequirement;
                        float medalOffset = (viewSize.x/2)-((sizeMedal+UI::MeasureString(""+count+"/"+total,fontHeaderSub).x)/2+16*UI::GetScale());
                        MoveCursor(vec2(medalOffset,-15.0));
                        RenderMedalProgress(GetProgressionTex(),sizeMedal,count,total);
                        MoveCursor(vec2(-medalOffset,-15.0));
                    }
                    else {
                        sizeMedal = (menu == "In map") ? 45 : 60;

                        int countGold = data.items.goldMedals;
                        int countAuthor = data.items.GetProgressionMedalCount();

                        int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 12 : data.victoryRequirement * 12;
                        int score = data.items.GetEqualizedPointCount();

                        float medalOffset = (viewSize.x/2)-((sizeMedal*2 + UI::MeasureString(""+countGold+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                        array<UI::Texture@> textures = {goldTex, authorTex};
                        array<int> medalCounts = {countGold, countAuthor};
                        MoveCursor(vec2(medalOffset,-15.0));
                        RenderMedalPossession(textures, sizeMedal, medalCounts);
                        MoveCursor(vec2(-medalOffset,-15.0));

                        float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                        UI::NewLine();
                        UI::NewLine();
                        MoveCursor(vec2(scoreOffset,-15.0));
                        RenderScore(score, pointRequirement);
                        MoveCursor(vec2(-scoreOffset,-15.0));
                    }
                }
                else if (goldMedalsDisabled){
                    sizeMedal = (menu == "In map") ? 45 : 60;

                    int countSilver = data.items.silverMedals;
                    int countAuthor = data.items.GetProgressionMedalCount();

                    int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 12 : data.victoryRequirement * 12;
                    int score = data.items.GetEqualizedPointCount();

                    float medalOffset = (viewSize.x/2)-((sizeMedal*2 + UI::MeasureString(""+countSilver+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                    array<UI::Texture@> textures = {silverTex, authorTex};
                    array<int> medalCounts = {countSilver, countAuthor};
                    MoveCursor(vec2(medalOffset,-15.0));
                    RenderMedalPossession(textures, sizeMedal, medalCounts);
                    MoveCursor(vec2(-medalOffset,-15.0));

                    float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                    UI::NewLine();
                    UI::NewLine();
                    MoveCursor(vec2(scoreOffset,-15.0));
                    RenderScore(score, pointRequirement);
                    MoveCursor(vec2(-scoreOffset,-15.0));
                }
                else{
                    sizeMedal = (menu == "In map") ? 25 : 60;

                    int countSilver = data.items.silverMedals;
                    int countGold = data.items.goldMedals;
                    int countAuthor = data.items.GetProgressionMedalCount();

                    int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 12 : data.victoryRequirement * 12;
                    int score = data.items.GetEqualizedPointCount();

                    float medalOffset = (viewSize.x/2)-((sizeMedal*3 + UI::MeasureString(""+countSilver+" "+countGold+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                    array<UI::Texture@> textures = {silverTex, goldTex, authorTex};
                    array<int> medalCounts = {countSilver, countGold, countAuthor};
                    MoveCursor(vec2(medalOffset,-15.0));
                    RenderMedalPossession(textures, sizeMedal, medalCounts);
                    MoveCursor(vec2(-medalOffset,-15.0));

                    float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                    UI::NewLine();
                    UI::NewLine();
                    MoveCursor(vec2(scoreOffset,-15.0));
                    RenderScore(score, pointRequirement);
                    MoveCursor(vec2(-scoreOffset,-15.0));
                }
            }
            else if (silverMedalsDisabled){
                if (goldMedalsDisabled){
                    sizeMedal = (menu == "In map") ? 45 : 60;

                    int countBronze = data.items.bronzeMedals;
                    int countAuthor = data.items.GetProgressionMedalCount();

                    int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 12 : data.victoryRequirement * 12;
                    int score = data.items.GetEqualizedPointCount();

                    float medalOffset = (viewSize.x/2)-((sizeMedal*2 + UI::MeasureString(""+countBronze+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                    array<UI::Texture@> textures = {bronzeTex, authorTex};
                    array<int> medalCounts = {countBronze, countAuthor};
                    MoveCursor(vec2(medalOffset,-15.0));
                    RenderMedalPossession(textures, sizeMedal, medalCounts);
                    MoveCursor(vec2(-medalOffset,-15.0));

                    float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                    UI::NewLine();
                    UI::NewLine();
                    MoveCursor(vec2(scoreOffset,-15.0));
                    RenderScore(score, pointRequirement);
                    MoveCursor(vec2(-scoreOffset,-15.0));
                }
                else{
                    sizeMedal = (menu == "In map") ? 25 : 60;

                    int countBronze = data.items.bronzeMedals;
                    int countGold = data.items.goldMedals;
                    int countAuthor = data.items.GetProgressionMedalCount();

                    int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 12 : data.victoryRequirement * 12;
                    int score = data.items.GetEqualizedPointCount();

                    float medalOffset = (viewSize.x/2)-((sizeMedal*3 + UI::MeasureString(""+countBronze+" "+countGold+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                    array<UI::Texture@> textures = {bronzeTex, goldTex, authorTex};
                    array<int> medalCounts = {countBronze, countGold, countAuthor};
                    MoveCursor(vec2(medalOffset,-15.0));
                    RenderMedalPossession(textures, sizeMedal, medalCounts);
                    MoveCursor(vec2(-medalOffset,-15.0));

                    float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                    UI::NewLine();
                    UI::NewLine();
                    MoveCursor(vec2(scoreOffset,-15.0));
                    RenderScore(score, pointRequirement);
                    MoveCursor(vec2(-scoreOffset,-15.0));
                }
            }
            else if (goldMedalsDisabled){
                sizeMedal = (menu == "In map") ? 25 : 60;

                int countBronze = data.items.bronzeMedals;
                int countSilver = data.items.silverMedals;
                int countAuthor = data.items.GetProgressionMedalCount();

                int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 12 : data.victoryRequirement * 12;
                int score = data.items.GetEqualizedPointCount();

                float medalOffset = (viewSize.x/2)-((sizeMedal*3 + UI::MeasureString(""+countBronze+" "+countSilver+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                array<UI::Texture@> textures = {bronzeTex, silverTex, authorTex};
                array<int> medalCounts = {countBronze, countSilver, countAuthor};
                MoveCursor(vec2(medalOffset,-15.0));
                RenderMedalPossession(textures, sizeMedal, medalCounts);
                MoveCursor(vec2(-medalOffset,-15.0));

                float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                UI::NewLine();
                UI::NewLine();
                MoveCursor(vec2(scoreOffset,-15.0));
                RenderScore(score, pointRequirement);
                MoveCursor(vec2(-scoreOffset,-15.0));
            }
            else{
                sizeMedal = (menu == "In map") ? 10 : 60;

                int countBronze = data.items.bronzeMedals;
                int countSilver = data.items.silverMedals;
                int countGold = data.items.goldMedals;
                int countAuthor = data.items.GetProgressionMedalCount();

                int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 12 : data.victoryRequirement * 12;
                int score = data.items.GetEqualizedPointCount();

                float medalOffset = (viewSize.x/2)-((sizeMedal*4 + UI::MeasureString(""+countBronze+" "+countSilver+" "+countGold+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                array<UI::Texture@> textures = {bronzeTex, silverTex, goldTex, authorTex};
                array<int> medalCounts = {countBronze, countSilver, countGold, countAuthor};
                MoveCursor(vec2(medalOffset,-15.0));
                RenderMedalPossession(textures, sizeMedal, medalCounts);
                MoveCursor(vec2(-medalOffset,-15.0));

                float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                UI::NewLine();
                UI::NewLine();
                MoveCursor(vec2(scoreOffset,-15.0));
                RenderScore(score, pointRequirement);
                MoveCursor(vec2(-scoreOffset,-15.0));
            }
        }
    }

    if (data.settings.progressionSystem == 2){
        if (targetTimeSetting < 1.0){
            int count = data.items.GetProgressionMedalCount();
            int total = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement : data.victoryRequirement;
            float medalOffset = (viewSize.x/2)-((sizeMedal+UI::MeasureString(""+count+"/"+total,fontHeaderSub).x)/2+16*UI::GetScale());
            MoveCursor(vec2(medalOffset,-15.0));
            RenderMedalProgress(GetProgressionTex(),sizeMedal,count,total);
            MoveCursor(vec2(-medalOffset,-15.0));
        }
    
        else if (targetTimeSetting < 2.0){
            if (bronzeMedalsDisabled){
                int count = data.items.GetProgressionMedalCount();
                int total = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement : data.victoryRequirement;
                float medalOffset = (viewSize.x/2)-((sizeMedal+UI::MeasureString(""+count+"/"+total,fontHeaderSub).x)/2+16*UI::GetScale());
                MoveCursor(vec2(medalOffset,-15.0));
                RenderMedalProgress(GetProgressionTex(),sizeMedal,count,total);
                MoveCursor(vec2(-medalOffset,-15.0));
            }
            else{
                sizeMedal = (menu == "In map") ? 45 : 60;

                int countBronze = data.items.bronzeMedals;
                int countSilver = data.items.GetProgressionMedalCount();

                int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 10 : data.victoryRequirement * 10;
                int score = data.items.GetPointCount();

                float medalOffset = (viewSize.x/2)-((sizeMedal*2 + UI::MeasureString(""+countBronze+" "+countSilver,fontHeaderSub).x)/2+16*UI::GetScale());
                array<UI::Texture@> textures = {bronzeTex, silverTex};
                array<int> medalCounts = {countBronze, countSilver};
                MoveCursor(vec2(medalOffset,-15.0));
                RenderMedalPossession(textures, sizeMedal, medalCounts);
                MoveCursor(vec2(-medalOffset,-15.0));

                float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                UI::NewLine();
                UI::NewLine();
                MoveCursor(vec2(scoreOffset,-15.0));
                RenderScore(score, pointRequirement);
                MoveCursor(vec2(-scoreOffset,-15.0));
            }
        }
        else if (targetTimeSetting < 3.0){
            if (bronzeMedalsDisabled){
                if (silverMedalsDisabled){
                    int count = data.items.GetProgressionMedalCount();
                    int total = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement : data.victoryRequirement;
                    float medalOffset = (viewSize.x/2)-((sizeMedal+UI::MeasureString(""+count+"/"+total,fontHeaderSub).x)/2+16*UI::GetScale());
                    MoveCursor(vec2(medalOffset,-15.0));
                    RenderMedalProgress(GetProgressionTex(),sizeMedal,count,total);
                    MoveCursor(vec2(-medalOffset,-15.0));
                }
                else{
                    sizeMedal = (menu == "In map") ? 45 : 60;

                    int countSilver = data.items.silverMedals;
                    int countGold = data.items.GetProgressionMedalCount();

                    int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 10 : data.victoryRequirement * 10;
                    int score = data.items.GetPointCount();

                    float medalOffset = (viewSize.x/2)-((sizeMedal*2 + UI::MeasureString(""+countSilver+" "+countGold,fontHeaderSub).x)/2+16*UI::GetScale());
                    array<UI::Texture@> textures = {silverTex, goldTex};
                    array<int> medalCounts = {countSilver, countGold};
                    MoveCursor(vec2(medalOffset,-15.0));
                    RenderMedalPossession(textures, sizeMedal, medalCounts);
                    MoveCursor(vec2(-medalOffset,-15.0));

                    float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                    UI::NewLine();
                    UI::NewLine();
                    MoveCursor(vec2(scoreOffset,-15.0));
                    RenderScore(score, pointRequirement);
                    MoveCursor(vec2(-scoreOffset,-15.0));
                }
            }
            else if (silverMedalsDisabled){
                sizeMedal = (menu == "In map") ? 45 : 60;

                int countBronze = data.items.bronzeMedals;
                int countGold = data.items.GetProgressionMedalCount();

                int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 10 : data.victoryRequirement * 10;
                int score = data.items.GetPointCount();

                float medalOffset = (viewSize.x/2)-((sizeMedal*2 + UI::MeasureString(""+countBronze+" "+countGold,fontHeaderSub).x)/2+16*UI::GetScale());
                array<UI::Texture@> textures = {bronzeTex, goldTex};
                array<int> medalCounts = {countBronze, countGold};
                MoveCursor(vec2(medalOffset,-15.0));
                RenderMedalPossession(textures, sizeMedal, medalCounts);
                MoveCursor(vec2(-medalOffset,-15.0));

                float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                UI::NewLine();
                UI::NewLine();
                MoveCursor(vec2(scoreOffset,-15.0));
                RenderScore(score, pointRequirement);
                MoveCursor(vec2(-scoreOffset,-15.0));
            }
            else{
                sizeMedal = (menu == "In map") ? 25 : 60;

                int countBronze = data.items.bronzeMedals;
                int countSilver = data.items.silverMedals;
                int countGold = data.items.GetProgressionMedalCount();

                int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 10 : data.victoryRequirement * 10;
                int score = data.items.GetPointCount();

                float medalOffset = (viewSize.x/2)-((sizeMedal*3 + UI::MeasureString(""+countBronze+" "+countSilver+" "+countGold,fontHeaderSub).x)/2+16*UI::GetScale());
                array<UI::Texture@> textures = {bronzeTex, silverTex, goldTex};
                array<int> medalCounts = {countBronze, countSilver, countGold};
                MoveCursor(vec2(medalOffset,-15.0));
                RenderMedalPossession(textures, sizeMedal, medalCounts);
                MoveCursor(vec2(-medalOffset,-15.0));

                float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                UI::NewLine();
                UI::NewLine();
                MoveCursor(vec2(scoreOffset,-15.0));
                RenderScore(score, pointRequirement);
                MoveCursor(vec2(-scoreOffset,-15.0));
            }
        }
        else{
            if (bronzeMedalsDisabled){
                if (silverMedalsDisabled){
                    if (goldMedalsDisabled){
                        int count = data.items.GetProgressionMedalCount();
                        int total = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement : data.victoryRequirement;
                        float medalOffset = (viewSize.x/2)-((sizeMedal+UI::MeasureString(""+count+"/"+total,fontHeaderSub).x)/2+16*UI::GetScale());
                        MoveCursor(vec2(medalOffset,-15.0));
                        RenderMedalProgress(GetProgressionTex(),sizeMedal,count,total);
                        MoveCursor(vec2(-medalOffset,-15.0));
                    }
                    else {
                        sizeMedal = (menu == "In map") ? 45 : 60;

                        int countGold = data.items.goldMedals;
                        int countAuthor = data.items.GetProgressionMedalCount();

                        int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 10 : data.victoryRequirement * 10;
                        int score = data.items.GetPointCount();

                        float medalOffset = (viewSize.x/2)-((sizeMedal*2 + UI::MeasureString(""+countGold+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                        array<UI::Texture@> textures = {goldTex, authorTex};
                        array<int> medalCounts = {countGold, countAuthor};
                        MoveCursor(vec2(medalOffset,-15.0));
                        RenderMedalPossession(textures, sizeMedal, medalCounts);
                        MoveCursor(vec2(-medalOffset,-15.0));

                        float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                        UI::NewLine();
                        UI::NewLine();
                        MoveCursor(vec2(scoreOffset,-15.0));
                        RenderScore(score, pointRequirement);
                        MoveCursor(vec2(-scoreOffset,-15.0));
                    }
                }
                else if (goldMedalsDisabled){
                    sizeMedal = (menu == "In map") ? 45 : 60;

                    int countSilver = data.items.silverMedals;
                    int countAuthor = data.items.GetProgressionMedalCount();

                    int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 10 : data.victoryRequirement * 10;
                    int score = data.items.GetPointCount();

                    float medalOffset = (viewSize.x/2)-((sizeMedal*2 + UI::MeasureString(""+countSilver+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                    array<UI::Texture@> textures = {silverTex, authorTex};
                    array<int> medalCounts = {countSilver, countAuthor};
                    MoveCursor(vec2(medalOffset,-15.0));
                    RenderMedalPossession(textures, sizeMedal, medalCounts);
                    MoveCursor(vec2(-medalOffset,-15.0));

                    float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                    UI::NewLine();
                    UI::NewLine();
                    MoveCursor(vec2(scoreOffset,-15.0));
                    RenderScore(score, pointRequirement);
                    MoveCursor(vec2(-scoreOffset,-15.0));
                }
                else{
                    sizeMedal = (menu == "In map") ? 25 : 60;

                    int countSilver = data.items.silverMedals;
                    int countGold = data.items.goldMedals;
                    int countAuthor = data.items.GetProgressionMedalCount();

                    int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 10 : data.victoryRequirement * 10;
                    int score = data.items.GetPointCount();

                    float medalOffset = (viewSize.x/2)-((sizeMedal*3 + UI::MeasureString(""+countSilver+" "+countGold+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                    array<UI::Texture@> textures = {silverTex, goldTex, authorTex};
                    array<int> medalCounts = {countSilver, countGold, countAuthor};
                    MoveCursor(vec2(medalOffset,-15.0));
                    RenderMedalPossession(textures, sizeMedal, medalCounts);
                    MoveCursor(vec2(-medalOffset,-15.0));

                    float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                    UI::NewLine();
                    UI::NewLine();
                    MoveCursor(vec2(scoreOffset,-15.0));
                    RenderScore(score, pointRequirement);
                    MoveCursor(vec2(-scoreOffset,-15.0));
                }
            }
            else if (silverMedalsDisabled){
                if (goldMedalsDisabled){
                    sizeMedal = (menu == "In map") ? 45 : 60;

                    int countBronze = data.items.bronzeMedals;
                    int countAuthor = data.items.GetProgressionMedalCount();

                    int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 10 : data.victoryRequirement * 10;
                    int score = data.items.GetPointCount();

                    float medalOffset = (viewSize.x/2)-((sizeMedal*2 + UI::MeasureString(""+countBronze+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                    array<UI::Texture@> textures = {bronzeTex, authorTex};
                    array<int> medalCounts = {countBronze, countAuthor};
                    MoveCursor(vec2(medalOffset,-15.0));
                    RenderMedalPossession(textures, sizeMedal, medalCounts);
                    MoveCursor(vec2(-medalOffset,-15.0));

                    float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                    UI::NewLine();
                    UI::NewLine();
                    MoveCursor(vec2(scoreOffset,-15.0));
                    RenderScore(score, pointRequirement);
                    MoveCursor(vec2(-scoreOffset,-15.0));
                }
                else{
                    sizeMedal = (menu == "In map") ? 25 : 60;

                    int countBronze = data.items.bronzeMedals;
                    int countGold = data.items.goldMedals;
                    int countAuthor = data.items.GetProgressionMedalCount();

                    int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 10 : data.victoryRequirement * 10;
                    int score = data.items.GetPointCount();

                    float medalOffset = (viewSize.x/2)-((sizeMedal*3 + UI::MeasureString(""+countBronze+" "+countGold+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                    array<UI::Texture@> textures = {bronzeTex, goldTex, authorTex};
                    array<int> medalCounts = {countBronze, countGold, countAuthor};
                    MoveCursor(vec2(medalOffset,-15.0));
                    RenderMedalPossession(textures, sizeMedal, medalCounts);
                    MoveCursor(vec2(-medalOffset,-15.0));

                    float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                    UI::NewLine();
                    UI::NewLine();
                    MoveCursor(vec2(scoreOffset,-15.0));
                    RenderScore(score, pointRequirement);
                    MoveCursor(vec2(-scoreOffset,-15.0));
                }
            }
            else if (goldMedalsDisabled){
                sizeMedal = (menu == "In map") ? 25 : 60;

                int countBronze = data.items.bronzeMedals;
                int countSilver = data.items.silverMedals;
                int countAuthor = data.items.GetProgressionMedalCount();

                int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 10 : data.victoryRequirement * 10;
                int score = data.items.GetPointCount();

                float medalOffset = (viewSize.x/2)-((sizeMedal*3 + UI::MeasureString(""+countBronze+" "+countSilver+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                array<UI::Texture@> textures = {bronzeTex, silverTex, authorTex};
                array<int> medalCounts = {countBronze, countSilver, countAuthor};
                MoveCursor(vec2(medalOffset,-15.0));
                RenderMedalPossession(textures, sizeMedal, medalCounts);
                MoveCursor(vec2(-medalOffset,-15.0));

                float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                UI::NewLine();
                UI::NewLine();
                MoveCursor(vec2(scoreOffset,-15.0));
                RenderScore(score, pointRequirement);
                MoveCursor(vec2(-scoreOffset,-15.0));
            }
            else{
                sizeMedal = (menu == "In map") ? 10 : 60;

                int countBronze = data.items.bronzeMedals;
                int countSilver = data.items.silverMedals;
                int countGold = data.items.goldMedals;
                int countAuthor = data.items.GetProgressionMedalCount();

                int pointRequirement = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement * 10 : data.victoryRequirement * 10;
                int score = data.items.GetPointCount();

                float medalOffset = (viewSize.x/2)-((sizeMedal*4 + UI::MeasureString(""+countBronze+" "+countSilver+" "+countGold+" "+countAuthor,fontHeaderSub).x)/2+16*UI::GetScale());
                array<UI::Texture@> textures = {bronzeTex, silverTex, goldTex, authorTex};
                array<int> medalCounts = {countBronze, countSilver, countGold, countAuthor};
                MoveCursor(vec2(medalOffset,-15.0));
                RenderMedalPossession(textures, sizeMedal, medalCounts);
                MoveCursor(vec2(-medalOffset,-15.0));

                float scoreOffset = (viewSize.x/2)-((UI::MeasureString(""+"Score : "+score+"/"+pointRequirement,fontHeaderSub).x)/2+16*UI::GetScale());
                UI::NewLine();
                UI::NewLine();
                MoveCursor(vec2(scoreOffset,-15.0));
                RenderScore(score, pointRequirement);
                MoveCursor(vec2(-scoreOffset,-15.0));
            }
        }
    }



    // default just in case
    else {
        int count = data.items.GetProgressionMedalCount();
        int total = (nextSeries < data.world.Length) ? data.world[nextSeries].medalRequirement : data.victoryRequirement;
        float medalOffset = (viewSize.x/2)-((sizeMedal+UI::MeasureString(""+count+"/"+total,fontHeaderSub).x)/2+16*UI::GetScale());
        MoveCursor(vec2(medalOffset,-15.0));
        RenderMedalProgress(GetProgressionTex(),sizeMedal,count,total);
        MoveCursor(vec2(-medalOffset,-15.0));
    }
}

void RenderVictory(vec2 viewSize){
    // default just in case
    int score = data.items.GetProgressionMedalCount();
    int pointRequirement = data.victoryRequirement;
    
    if (data.settings.progressionSystem == 0){
        score = data.items.GetProgressionMedalCount();
        pointRequirement = data.victoryRequirement;
    }
    if (data.settings.progressionSystem == 1){
        score = data.items.GetEqualizedPointCount();
        pointRequirement = data.victoryRequirement * 12;
    }
    if (data.settings.progressionSystem == 2){
        score = data.items.GetPointCount();
        pointRequirement = data.victoryRequirement * 10;
    }
    
    MoveCursor(vec2(0,10));
    string text = "Victory";
    if (score >= pointRequirement) text = "Victory!!!!! :D";
    UI::PushFont(fontHeader);
    vec4 color = vec4(0.5,0.5,0.5,1.0);
    if (score >= pointRequirement){
        color = (vec4(0.0,1.0,0.1,1.0));
    }
    UI::PushStyleColor(UI::Col::Text,color);
    vec2 stringSize = UI::MeasureString(text,fontHeader);
    float textOffset = (viewSize.x/2)-(stringSize.x/2);
    MoveCursor(vec2(textOffset,0.0));
    UI::Text(text);
    MoveCursor(vec2(-textOffset,0.0));
    UI::PopStyleColor();
    UI::PopFont();
    UI::NewLine();
}

void RenderTextCentered(const string &in text, UI::Font@ font, int fontSize){
    vec2 size = UI::MeasureString(text, font, fontSize);
    MoveCursor(size/-2);
    UI::PushFont(font);
    UI::PushFontSize(fontSize);
    UI::Text(text);
    UI::PopFontSize();
    UI::PopFont();
    MoveCursor(size/2);
}

void MoveCursor(vec2 offset){
    vec2 curs = UI::GetCursorPos();
    curs += offset;
    UI::SetCursorPos(curs);
}

UI::Texture@ GetProgressionTex(){
    float timeSetting = data.settings.targetTimeSetting;
    if (timeSetting < 1){
        return bronzeTex;
    }else if (timeSetting < 2){
        return silverTex;
    }else if (timeSetting < 3){
        return goldTex;
    }else{
        return authorTex;
    }
}

#if TMNEXT
nvg::Texture@ GetNthSmolTex(ItemTypes type){
    switch (type){
        case ItemTypes::BronzeMedal:
            return bronzeTexNVGSmol;
        case ItemTypes::SilverMedal:
            return silverTexNVGSmol;
        case ItemTypes::GoldMedal:
            return goldTexNVGSmol;
        case ItemTypes::AuthorMedal:
            return authorTexNVGSmol;
        case ItemTypes::Archipelago:
            return archipelagoTexNVGSmol;
        case ItemTypes::Skip:
            return archipelagoTexNVGSmol;
        case ItemTypes::Discount:
            return archipelagoTexNVGSmol;
        case ItemTypes::Trap:
            return archipelagoTexNVGSmol;
        case ItemTypes::Filler:
            return archipelagoTexNVGSmol;
        default:
            return archipelagoTexNVGSmol;
    }
}

nvg::Texture@ GetNthMedTex(ItemTypes type){
    switch (type){
        case ItemTypes::BronzeMedal:
            return bronzeTexNVGMed;
        case ItemTypes::SilverMedal:
            return silverTexNVGMed;
        case ItemTypes::GoldMedal:
            return goldTexNVGMed;
        case ItemTypes::AuthorMedal:
            return authorTexNVGMed;
        case ItemTypes::Archipelago:
            return archipelagoTexNVGMed;
        case ItemTypes::Skip:
            return archipelagoTexNVGMed;
        case ItemTypes::Discount:
            return archipelagoTexNVGMed;
        case ItemTypes::Trap:
            return archipelagoTexNVGMed;
        case ItemTypes::Filler:
            return archipelagoTexNVGMed;
        default:
            return archipelagoTexNVGMed;
    }
}

string GetNthName(ItemTypes type){
    switch (type){
        case ItemTypes::BronzeMedal:
            return "Bronze";
        case ItemTypes::SilverMedal:
            return "Silver";
        case ItemTypes::GoldMedal:
            return "Gold";
        case ItemTypes::AuthorMedal:
            return "Author";
        case ItemTypes::Archipelago:
            return "Archipelago Item";
        case ItemTypes::Skip:
            return "Map Skip";
        case ItemTypes::Discount:
            return "PB Discount";
        case ItemTypes::Trap:
            return "Trap Item";
        case ItemTypes::Filler:
            return "Filler Item";
        default:
            return "Archipelago Item";
    }
}
#endif

nvg::Texture@ GetNthTex(ItemTypes type){
    switch (type){
        case ItemTypes::BronzeMedal:
            return bronzeTexNVG;
        case ItemTypes::SilverMedal:
            return silverTexNVG;
        case ItemTypes::GoldMedal:
            return goldTexNVG;
        case ItemTypes::AuthorMedal:
            return authorTexNVG;
        case ItemTypes::Archipelago:
            return archipelagoTexNVG;
        case ItemTypes::Skip:
            return archipelagoTexNVG;
        case ItemTypes::Discount:
            return archipelagoTexNVG;
        case ItemTypes::Trap:
            return archipelagoTexNVG;
        case ItemTypes::Filler:
            return archipelagoTexNVG;
        default:
            return archipelagoTexNVG;
    }
}

#if MP4
nvg::Texture@ GetNthBottomTex(ItemTypes type){
    switch (type){
        case ItemTypes::BronzeMedal:
            return bronzeTexNVGBottom;
        case ItemTypes::SilverMedal:
            return silverTexNVGBottom;
        case ItemTypes::GoldMedal:
            return goldTexNVGBottom;
        case ItemTypes::AuthorMedal:
            return authorTexNVGBottom;
        case ItemTypes::Archipelago:
            return archipelagoTexNVGBottom;
        case ItemTypes::Skip:
            return archipelagoTexNVGBottom;
        case ItemTypes::Discount:
            return archipelagoTexNVGBottom;
        case ItemTypes::Trap:
            return archipelagoTexNVGBottom;
        case ItemTypes::Filler:
            return archipelagoTexNVGBottom;
        default:
            return archipelagoTexNVGBottom;
    }
}

nvg::Texture@ GetNthBowTieTex(ItemTypes type){
    switch (type){
        case ItemTypes::BronzeMedal:
            return bronzeTexNVGBowTie;
        case ItemTypes::SilverMedal:
            return silverTexNVGBowTie;
        case ItemTypes::GoldMedal:
            return goldTexNVGBowTie;
        case ItemTypes::AuthorMedal:
            return authorTexNVGBowTie;
        case ItemTypes::Archipelago:
            return archipelagoTexNVGBowTie;
        case ItemTypes::Skip:
            return archipelagoTexNVGBowTie;
        case ItemTypes::Discount:
            return archipelagoTexNVGBowTie;
        case ItemTypes::Trap:
            return archipelagoTexNVGBowTie;
        case ItemTypes::Filler:
            return archipelagoTexNVGBowTie;
        default:
            return archipelagoTexNVGBowTie;
    }
}

#endif

void DrawChecksRemaining(int seriesI, int mapI, bool showNone = true){
    string render = "";
    if (!data.locations.GotCheck(seriesI, mapI, CheckTypes::Target)){
        render += "\\$fff"+Icons::Circle + "\\$z ";
    }
    if (!data.locations.GotCheck(seriesI, mapI, CheckTypes::Author) && data.settings.DoingAuthor()){
        render += "\\$0a6"+Icons::Circle + "\\$z ";
    }
    if (!data.locations.GotCheck(seriesI, mapI, CheckTypes::Gold) && data.settings.DoingGold()){
        render += "\\$fc4"+Icons::Circle + "\\$z ";
    }
    if (!data.locations.GotCheck(seriesI, mapI, CheckTypes::Silver) && data.settings.DoingSilver()){
        render += "\\$888"+Icons::Circle + "\\$z ";
    }
    if (!data.locations.GotCheck(seriesI, mapI, CheckTypes::Bronze) && data.settings.DoingBronze()){
        render += "\\$964"+Icons::Circle + "\\$z ";
    }
    if (data.locations.GotAllChecks(seriesI, mapI) && showNone){
        render += "None! :D";
    }
    UI::Text(render);
}

void DrawTags(MapState@ mapState, bool wrap = true){
    string render = "";
    MapInfo@ map = mapState.mapInfo;
    for(uint i = 0; i < map.Tags.Length; i++){
        render += map.Tags[i].Name;
        if (i < map.Tags.Length-1){
            render += ", ";
        }
    }
    if (render.Length > 0){
        if (wrap){
            UI::TextWrapped(render);
        }else{
            UI::Text(render);
        }
    }

}

void LoadUIAssets(){
    if (IS_DEV_MODE) print("Loading Sounds...");
    @victoryClip = Audio::LoadSample("Sounds/Victory.wav");
    yield();

    if (IS_DEV_MODE) print("Loading Fonts...");
    @fontHeader = UI::LoadFont("DroidSans-Bold.ttf", 26);
    //yield();
    @fontHeaderSub = UI::LoadFont("DroidSans.ttf", 22);
    //yield();
    @fontTime = UI::LoadFont("Fonts/digital-7.mono.ttf", 18);
    //yield();
    NvgFont = nvg::LoadFont("Fonts/RacingSansOne-Regular.ttf");
    yield();

    if (IS_DEV_MODE) print("Loading Textures...");
#if TMNEXT
    @bronzeTex = UI::LoadTexture("Images/TMNEXT/bronzeMed.png");
    @silverTex = UI::LoadTexture("Images/TMNEXT/silverMed.png");
    @goldTex = UI::LoadTexture("Images/TMNEXT/goldMed.png");
    @authorTex = UI::LoadTexture("Images/TMNEXT/authorMed.png");
    yield();
#elif MP4
    @bronzeTex = UI::LoadTexture("Images/MP4/bronzeTopMedMP4.png");
    @silverTex = UI::LoadTexture("Images/MP4/silverTopMedMP4.png");
    @goldTex = UI::LoadTexture("Images/MP4/goldTopMedMP4.png");
    @authorTex = UI::LoadTexture("Images/MP4/authorTopMedMP4.png");
    yield();
#endif

#if TMNEXT
    @bronzeTexNVG = nvg::LoadTexture("Images/TMNEXT/bronze.png");
    @silverTexNVG = nvg::LoadTexture("Images/TMNEXT/silver.png");
    @goldTexNVG = nvg::LoadTexture("Images/TMNEXT/gold.png");
    yield();
    @authorTexNVG = nvg::LoadTexture("Images/TMNEXT/author.png");
    @archipelagoTexNVG = nvg::LoadTexture("Images/TMNEXT/archipelago.png");
    yield();
    @bronzeTexNVGMed = nvg::LoadTexture("Images/TMNEXT/bronzeMed.png");
    @silverTexNVGMed = nvg::LoadTexture("Images/TMNEXT/silverMed.png");
    @goldTexNVGMed = nvg::LoadTexture("Images/TMNEXT/goldMed.png");
    @authorTexNVGMed = nvg::LoadTexture("Images/TMNEXT/authorMed.png");
    @archipelagoTexNVGMed = nvg::LoadTexture("Images/TMNEXT/archipelagoMed.png");
    yield();
    @bronzeTexNVGSmol = nvg::LoadTexture("Images/TMNEXT/bronzeSmall.png");
    @silverTexNVGSmol = nvg::LoadTexture("Images/TMNEXT/silverSmall.png");
    @goldTexNVGSmol = nvg::LoadTexture("Images/TMNEXT/goldSmall.png");
    @authorTexNVGSmol = nvg::LoadTexture("Images/TMNEXT/authorSmall.png");
    @archipelagoTexNVGSmol = nvg::LoadTexture("Images/TMNEXT/archipelagoSmall.png");

    @shadowTexNVG = nvg::LoadTexture("Images/TMNEXT/shadow.png");

#elif MP4
    @bronzeTexNVG = nvg::LoadTexture("Images/MP4/bronzeTopMP4.png");
    @silverTexNVG = nvg::LoadTexture("Images/MP4/silverTopMP4.png");
    @goldTexNVG = nvg::LoadTexture("Images/MP4/goldTopMP4.png");
    yield();
    @authorTexNVG = nvg::LoadTexture("Images/MP4/authorTopMP4.png");
    @archipelagoTexNVG = nvg::LoadTexture("Images/MP4/archipelagoTopMP4.png");
    yield();
    @bronzeTexNVGBowTie = nvg::LoadTexture("Images/MP4/bronzeMP4.png");
    @silverTexNVGBowTie = nvg::LoadTexture("Images/MP4/silverMP4.png");
    @goldTexNVGBowTie = nvg::LoadTexture("Images/MP4/goldMP4.png");
    yield();
    @authorTexNVGBowTie = nvg::LoadTexture("Images/MP4/authorMP4.png");
    @archipelagoTexNVGBowTie = nvg::LoadTexture("Images/MP4/archipelagoMP4.png");
    yield();
    @bronzeTexNVGBottom = nvg::LoadTexture("Images/MP4/bronzeBottomMP4.png");
    @silverTexNVGBottom = nvg::LoadTexture("Images/MP4/silverBottomMP4.png");
    @goldTexNVGBottom = nvg::LoadTexture("Images/MP4/goldBottomMP4.png");
    yield();
    @authorTexNVGBottom = nvg::LoadTexture("Images/MP4/authorBottomMP4.png");
    @archipelagoTexNVGBottom = nvg::LoadTexture("Images/MP4/archipelagoBottomMP4.png");
#endif

    loadingFinished = true;
}