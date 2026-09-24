def test_add_and_get_suggestion(manifest):
    s = manifest.add_suggestion("silicons on the lobby crew manifest", author="wizrible_85696")
    assert isinstance(s, Suggestion)
    assert s.text == "silicons on the lobby crew manifest"
    assert s.author == "wizrible_85696"

    # retrieval (case-insensitive)
    fetched = manifest.get_suggestion(" SILICONS ON THE LOBBY CREW MANIFEST ")
    assert fetched == s
