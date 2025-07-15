// Counts all files regardless of type
// B L Weare, @NMRC 14-03-24

TagGroup CreateFileList( string folder, number inclSubFolder )
{
	TagGroup filesTG = GetFilesInDirectory( folder , 1 )
	TagGroup fileList = NewTagList()
	for (number i = 0; i < filesTG.TagGroupCountTags() ; i++ )
	{
		TagGroup entryTG
		if ( filesTG.TagGroupGetIndexedTagAsTagGroup( i , entryTG ) )
		{
			string fileName
			if ( entryTG.TagGroupGetTagAsString( "Name" , fileName ) )
			{
				filelist.TagGroupInsertTagAsString( fileList.TagGroupCountTags() , PathConcatenate( folder , fileName ) )
			}
		}
	}

	TagGroup allFolders = GetFilesInDirectory( folder, 2 )
	number nFolders = allFolders.TagGroupCountTags()
	for ( number i = 0; i < nFolders; i++ )
	{
		string sfolder
		TagGroup entry
		allFolders.TagGroupgetIndexedTagAsTagGroup( i , entry )
		entry.TagGroupGetTagAsString( "Name" , sfolder )
		sfolder = StringToLower( sfolder )
		TagGroup SubList = CreateFileList( PathConcatenate( folder , sfolder ) , inclSubFolder )
		for ( number j = 0; j < SubList.TagGroupCountTags(); j++ )
		{
			string file
			if ( SubList.tagGroupGetIndexedTagAsString( j , file ) )
			fileList.TagGroupInsertTagAsString( Infinity() , file )
		}
	}   
	return fileList
}

// Function converts a string to lower-case characters
string ToLowerCase( string in )
{
	string out = ""
	for( number c = 0 ; c < len( in ) ; c++ )
	{
		string letter = mid( in , c , 1 )
        number n = asc( letter )
        if ( ( n > 64 ) && ( n < 91 ) )        letter = chr( n + 32 )
        out += letter
	}        
	return out
}

// Function removes entries not matching in suffix
TagGroup FilterFilesList( TagGroup list, string suffix )
{
	TagGroup outList = NewTagList()
	suffix = ToLowerCase( suffix )
	for ( number i = 0 ; i < list.TagGroupCountTags() ; i++ )
	{
		string origstr
        if ( list.TagGroupGetIndexedTagAsString( i , origstr ) ) 
        {
			string str = ToLowerCase( origstr )
			number matches = 1
			if ( len( str ) >= len( suffix ) )                 // Ensure that the suffix isn't longer than the whole string
			{
				if ( suffix == right( str , len( suffix ) ) ) // Compare suffix to end of original string
				{
					outList.TagGroupInsertTagAsString( outList.TagGroupCountTags() , origstr )        // Copy if matching
				}
			}
		}
	}
	return outList
}


void MainRoutine( string folder, number input, string extension )
{
	TagGroup fileslist = CreateFileList( folder, input )
	TagGroup filteredlist = FilterFilesList( fileslist, extension )
	number nfiles = filteredlist.TagGroupCountTags( )
	number raw = fileslist.TagGroupCountTags( )
	result( raw + " " + nfiles + "\n" )
}

//script starts here

number input = 1
string folder = "F:\\EM Data\\FEG\\Calibration Samples\\Salt\\26-02-24\\salt_260225_01\\Hour_00"
string extension = ".dm4"

MainRoutine( folder, input, extension )
//end