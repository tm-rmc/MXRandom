namespace MainUIView
{
    void Header()
    {
        vec2 pos_orig = UI::GetCursorPos();
        if (!MX::RandomMapIsLoading) {
            UI::SetCursorPos(vec2(UI::GetWindowSize().x*0.36, 35));
            if (UI::GreenButton(Icons::Play + " Play a random map")) {
                startnew(MX::LoadRandomMap);
            }
        } else {
            UI::SetCursorPos(vec2(UI::GetWindowSize().x*0.42, 35));
            int HourGlassValue = Time::Stamp % 3;
            string Hourglass = (HourGlassValue == 0 ? Icons::HourglassStart : (HourGlassValue == 1 ? Icons::HourglassHalf : Icons::HourglassEnd));
            UI::Text(Hourglass + " Loading...");
        }
        UI::SetCursorPos(vec2(UI::GetWindowSize().x*0.34, 70));
        if (UI::ColoredButton(Icons::ClockO +" Random Map Challenge", 0.155)) {
            window.isInRMCMode = !window.isInRMCMode;
        }

        UI::SetCursorPos(vec2(0, 100));
        UI::Separator();
    }

    void RecentlyPlayedMapsTab()
    {
        UI::Text("Recently played maps");
    }

    void ChangelogTabs()
    {
        GH::CheckReleasesReq();
        if (GH::ReleasesReq is null && GH::Releases.Length == 0) {
            if (!GH::releasesRequestError) {
                GH::StartReleasesReq();
            } else {
                UI::Text("Error while loading releases");
            }
        }
        if (GH::ReleasesReq !is null) {
            int HourGlassValue = Time::Stamp % 3;
            string Hourglass = (HourGlassValue == 0 ? Icons::HourglassStart : (HourGlassValue == 1 ? Icons::HourglassHalf : Icons::HourglassEnd));
            UI::Text(Hourglass + " Loading...");
        }

        if (GH::ReleasesReq is null && GH::Releases.Length > 0) {
            UI::BeginTabBar("MainUISettingsTabBar", UI::TabBarFlags::FittingPolicyScroll);
            for (int i = 0; i < GH::Releases.Length; i++) {
                GH::Release@ release = GH::Releases[i];

                if (UI::BeginTabItem((release.name.Replace('v', '') == PLUGIN_VERSION ? "\\$090": "") + Icons::Tag + " \\$z" + release.name)) {
                    UI::BeginChild("Changelog"+release.name);
                    UI::Markdown(Render::FormatChangelogBody(release.body));
                    UI::EndChild();
                    UI::EndTabItem();
                }
            }
            UI::EndTabBar();
        }
    }
}