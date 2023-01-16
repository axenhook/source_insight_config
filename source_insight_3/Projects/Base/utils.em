/* 
  Utils.em - a small collection of useful editing macros 
  ������ zeng_hr@163.com ����޸���2009��7��5��
*/

// ��ȡ�û�ע����Ϣ
macro GetUserRegInfo()
{
	global userInfo

	if (userInfo == nil)
	{
		userInfo.language = getreg(USER_LANGUAGE) // ��ȡ����
		userInfo.authorEn = getreg(USER_AUTHOR_EN) // ��ȡ����Ӣ������
		userInfo.companyEn = getreg(USER_COMPANY_EN) // ��ȡ����Ӣ�Ĺ�˾����
		userInfo.authorCh = getreg(USER_AUTHOR_CH) // ��ȡ������������
		userInfo.companyCh = getreg(USER_COMPANY_CH) // ��ȡ�������Ĺ�˾����
	}
	
	//Msg(userInfo.language)
	//Msg(userInfo.authorEn)
	//Msg(userInfo.companyEn)
	//Msg(userInfo.authorCh)
	//Msg(userInfo.companyCh)
}

// �ı��û�ע����Ϣ
macro ChangeUserInfo()
{
	GetUserRegInfo()
	
	while (1)
	{ // ����������Ҫ������
		language = Ask("Please input your favorate language, 0 for English, other number for Chinese:")
		if (IsNumber(language))
		{ // ������
			if (language == 0)
			{
				SetReg(USER_LANGUAGE, "English")
				userInfo.language = "English"
			}
			else
			{
				SetReg(USER_LANGUAGE, "����")
				userInfo.language = "����"
			}
			break;
		}
		else
		{ // ��������
			//Beep()
			Msg("The input should be a number!")
		}
	}

	if (userInfo.language == "English")
	{ // Ӣ��
		// �������ߵ�����
		userInfo.authorEn = Ask("Please input author name:")
		SetReg(USER_AUTHOR_EN, userInfo.authorEn)
		
		// ���빫˾����
		userInfo.companyEn = Ask("Please input company name:")
		SetReg(USER_COMPANY_EN, userInfo.companyEn)
	}
	else
	{ // ����
		// �������ߵ�����
		userInfo.authorCh = Ask("��������������:")
		SetReg(USER_AUTHOR_CH, userInfo.authorCh)
		
		// ���빫˾����
		userInfo.companyCh = Ask("�����빫˾����:")
		SetReg(USER_COMPANY_CH, userInfo.companyCh)
	}
}

// ����û�ע����Ϣ������
macro GetAndCheckUserRegInfo()
{
	GetUserRegInfo()

	if ((strlen(userInfo.language) == 0) // û���������Ի��߲��Ϸ�
		|| ((userInfo.language == "English") && (!strlen(userInfo.authorEn) || !strlen(userInfo.companyEn))) // Ӣ����Ϣ��ȫ
		|| ((userInfo.language != "English") && (!strlen(userInfo.authorCh) || !strlen(userInfo.companyCh))) // ������Ϣ��ȫ
		)
	{
		ChangeUserInfo()
	}
}

// ����Ӣ���ļ�ͷ
macro InsertFileHeaderEn()
{
	szSysTime = GetSysTime(0) // ��ǰϵͳʱ��
	szDueYear = szSysTime.year+3 // ��Ȩ������
	
	hbuf = GetCurrentBuf()

	sz = GetBufName(hbuf) // ��ȡ�ļ���
	len = strlen(sz)
	while(strmid(sz, len - 1, len) != "\\")
	{
		len = len -1
	}
	szFileName = toupper(strmid(sz, len, strlen(sz)))
	
	InsBufLine(hbuf, 0, "/*******************************************************************************")
	InsBufLine(hbuf, 1, "")
	
	sz = "            Copyright(C), "
	sz = cat(sz, szSysTime.year)
	sz = cat(sz, "~")
	sz = cat(sz, szSysTime.year+3)
	sz = cat(sz, ", ")
	sz = cat(sz, userInfo.companyEn)
	InsBufLine(hbuf, 2, sz) // �����Ȩ��Ϣ

	InsBufLine(hbuf, 3, "********************************************************************************")
	
	sz = "File Name: "
	sz = cat(sz, szFileName)
	InsBufLine(hbuf, 4, sz) // �����ļ���
	
	sz = "Author   : "
	sz = cat(sz, userInfo.authorEn)
	InsBufLine(hbuf, 5, sz) // ��������
	
	InsBufLine(hbuf, 6, "Version  : 1.00") // ����汾��Ϣ
	
	sz = "Date     : "
	sz = cat(sz, GetCurDateEn(szSysTime))
	InsBufLine(hbuf, 7, sz) // ���봴������
	
	InsBufLine(hbuf, 8, "Description: ")
	InsBufLine(hbuf, 9, "Function List: ")
	InsBufLine(hbuf, 10, "    1. ...: ")
	InsBufLine(hbuf, 11, "History: ")
	
	sz = cat("    Version: 1.00  Author: ", userInfo.authorEn)
	sz = cat(sz, "  Date: ")
	sz = cat(sz, GetCurDateEn(szSysTime))
	InsBufLine(hbuf, 12,  sz) // �����޸���ʷ
	
	InsBufLine(hbuf, 13, "--------------------------------------------------------------------------------")
	InsBufLine(hbuf, 14, "    1. Primary version")
	InsBufLine(hbuf, 15, "*******************************************************************************/")

	SetBufIns(hbuf, 8, 10)
}

// ���������ļ�ͷ
macro InsertFileHeaderCh()
{
	szSysTime = GetSysTime(0) // ��ǰϵͳʱ��
	szDueYear = szSysTime.year+3 // ��Ȩ������
	
	hbuf = GetCurrentBuf()

	sz = GetBufName(hbuf) // ��ȡ�ļ���
	len = strlen(sz)
	while(strmid(sz, len - 1, len) != "\\")
	{
		len = len -1
	}
	szFileName = toupper(strmid(sz, len, strlen(sz)))
	
	InsBufLine(hbuf, 0, "/*******************************************************************************")
	InsBufLine(hbuf, 1, "")
	
	sz = "            ��Ȩ����(C), "
	sz = cat(sz, szSysTime.year)
	sz = cat(sz, "~")
	sz = cat(sz, szSysTime.year+3)
	sz = cat(sz, ", ")
	sz = cat(sz, userInfo.companyCh)
	InsBufLine(hbuf, 2, sz) // �����Ȩ��Ϣ

	InsBufLine(hbuf, 3, "********************************************************************************")
	
	sz = "�� �� ��: "
	sz = cat(sz, szFileName)
	InsBufLine(hbuf, 4, sz) // �����ļ���
	
	sz = "��    ��: "
	sz = cat(sz, userInfo.authorCh)
	InsBufLine(hbuf, 5, sz) // ��������
	
	InsBufLine(hbuf, 6, "��    ��: 1.00") // ����汾��Ϣ
	
	sz = "��    ��: "
	sz = cat(sz, GetCurDateCh(szSysTime))
	InsBufLine(hbuf, 7, sz) // ���봴������
	
	InsBufLine(hbuf, 8, "��������: ")
	InsBufLine(hbuf, 9, "�����б�: ")
	InsBufLine(hbuf, 10, "    1. ...: ")
	InsBufLine(hbuf, 11, "�޸���ʷ: ")
	
	sz = cat("    �汾��1.00  ����: ", userInfo.authorCh)
	sz = cat(sz, "  ����: ")
	sz = cat(sz, GetCurDateCh(szSysTime))
	InsBufLine(hbuf, 12,  sz) // �����޸���ʷ
	
	InsBufLine(hbuf, 13, "--------------------------------------------------------------------------------")
	InsBufLine(hbuf, 14, "    1. ��ʼ�汾")
	InsBufLine(hbuf, 15, "*******************************************************************************/")

	SetBufIns(hbuf, 8, 10)
}

// �����ļ�ͷ
macro InsertFileHeader()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		InsertFileHeaderEn()
	}
	else
	{
		InsertFileHeaderCh()
	}
}

macro InsertReviseHistory()
{
	GetAndCheckUserRegInfo()
	
	hbuf = GetCurrentBuf()
	
	if (userInfo.language == "English")
	{
		sz = cat("    Version: 1.00  Author: ", userInfo.authorEn)
		sz = cat(sz, "  Date: ")
		sz = cat(sz, GetCurDateEn(GetSysTime(0)))
	}
	else
	{
		sz = cat("    �汾��1.00  ����: ", userInfo.authorCh)
		sz = cat(sz, "  ����: ")
		sz = cat(sz, GetCurDateCh(GetSysTime(0)))
	}
	
	ln = GetBufLnCur(hbuf)
	InsBufLine(hbuf, ln, sz)
	InsBufLine(hbuf, ln + 1, "--------------------------------------------------------------------------------")
	InsBufLine(hbuf, ln + 2, "    1. ")
	SetBufIns(hbuf, ln + 2, 7)
}

// ��ȡ��ǰ��Ӣ��������Ϣ
macro GetCurDateEn(szSysTime)
{
	sz = ""
	if (strlen(szSysTime.day) < 2)
	{
		sz = cat(sz, "0")
	}
	sz = cat(sz, szSysTime.day)
	sz = cat(sz, "/")
	if (szSysTime.month == 1)
	{
		sz = cat(sz, "Jan")
	}
	if (szSysTime.month == 2)
	{
		sz = cat(sz, "Feb")
	}
	if (szSysTime.month == 3)
	{
		sz = cat(sz, "Mar")
	}
	if (szSysTime.month == 4)
	{
		sz = cat(sz, "Apr")
	}
	if (szSysTime.month == 5)
	{
		sz = cat(sz, "May")
	}
	if (szSysTime.month == 6)
	{
		sz = cat(sz, "Jun")
	}
	if (szSysTime.month == 7)
	{
		sz = cat(sz, "Jul")
	}
	if (szSysTime.month == 8)
	{
		sz = cat(sz, "Aug")
	}
	if (szSysTime.month == 9)
	{
		sz = cat(sz, "Sep")
	}
	if (szSysTime.month == 10)
	{
		sz = cat(sz, "Oct")
	}
	if (szSysTime.month == 11)
	{
		sz = cat(sz, "Nov")
	}
	if (szSysTime.month == 12)
	{
		sz = cat(sz, "Dec")
	}
	sz = cat(sz, "/")
	sz = cat(sz, szSysTime.year)
	return sz
}

// ��ȡ��ǰ������������Ϣ
macro GetCurDateCh(szSysTime)
{
	sz = ""
	sz = cat(sz, szSysTime.year)
	sz = cat(sz, "��")
	sz = cat(sz, szSysTime.month)
	sz = cat(sz, "��")
	sz = cat(sz, szSysTime.day)
	sz = cat(sz, "��")
	return sz
}

// ����ṹ��
macro InsertStruct()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		szStructName = Ask("Please enter the StructType name:")
	}
	else
	{
		szStructName = Ask("������ṹ�������:")
	}
	
	hbuf = GetCurrentBuf()
	ln = GetBufLnCur(hbuf)
	//szStructName = toupper(szStructName)
	sz = cat("_", szStructName)
	
	InsBufLine(hbuf, ln, "typedef struct @sz@")
	InsBufLine(hbuf, ln + 1, "{")
	InsBufLine(hbuf, ln + 2, "    ")
	InsBufLine(hbuf, ln + 3, "} @szStructName@;")
	SetBufIns(hbuf, ln + 2, 5)
}

// ����������
macro InsertUnion()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		szUnionName = Ask("Please enter the UnionType name:")
	}
	else
	{
		szUnionName = Ask("�����������������:")
	}
	
	hbuf = GetCurrentBuf()
	ln = GetBufLnCur(hbuf)
	//szUnionName = toupper(szUnionName)
	sz = cat("_", szUnionName)
	
	InsBufLine(hbuf, ln, "typedef union @sz@")
	InsBufLine(hbuf, ln + 1, "{")
	InsBufLine(hbuf, ln + 2, "    ")
	InsBufLine(hbuf, ln + 3, "} @szUnionName@;")
	SetBufIns(hbuf, ln + 2, 5)
}

// ������
macro InsertClass()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		szClassName = Ask("Please enter the class name:")
	}
	else
	{
		szClassName = Ask("�������������:")
	}
	
	hbuf = GetCurrentBuf()
	ln = GetBufLnCur(hbuf)
	
	InsBufLine(hbuf, ln, "class @szClassName@")
	InsBufLine(hbuf, ln + 1, "{")
	InsBufLine(hbuf, ln + 2, "    ")
	InsBufLine(hbuf, ln + 3, "};")
	SetBufIns(hbuf, ln + 2, 5)
}

// ����ö��
macro InsertEnum()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		szEnumName = Ask("Please enter the enum name:")
	}
	else
	{
		szEnumName = Ask("������ö���������:")
	}
	
	hbuf = GetCurrentBuf()
	ln = GetBufLnCur(hbuf)
	//szStructName = toupper(szEnumName)
	sz = cat("_", szEnumName)
	
	InsBufLine(hbuf, ln, "typedef enum @sz@")
	InsBufLine(hbuf, ln + 1, "{")
	InsBufLine(hbuf, ln + 2, "    ")
	InsBufLine(hbuf, ln + 3, "} @szEnumName@;")
	SetBufIns(hbuf, ln + 2, 5)
}

// ���뺯��ͷ
macro InsertFuncHeader(szFuncName)
{
	if (szFuncName != "")
	{
		hbuf = GetCurrentBuf()
		ln = GetBufLnCur(hbuf)

		if (userInfo.language == "English")
		{
			InsBufLine(hbuf, ln,     "/*******************************************************************************")
			InsBufLine(hbuf, ln + 1, "Function: @szFuncName@")
			InsBufLine(hbuf, ln + 2, "Descript: None")
			InsBufLine(hbuf, ln + 3, "Input   : None")
			InsBufLine(hbuf, ln + 4, "Output  : None")
			InsBufLine(hbuf, ln + 5, "Return  :")
			InsBufLine(hbuf, ln + 6, "    >=0: SUCCESS")
			InsBufLine(hbuf, ln + 7, "    < 0: Error code")
			sz = cat("Author  : ", userInfo.authorEn)
			InsBufLine(hbuf, ln + 8, sz)
			sz = cat("Date    : ", GetCurDateEn(GetSysTime(0)))
			InsBufLine(hbuf, ln + 9, sz)
			InsBufLine(hbuf, ln + 10, "Others  : None")
			InsBufLine(hbuf, ln + 11, "*******************************************************************************/")
		}
		else
		{
			InsBufLine(hbuf, ln,     "/*******************************************************************************")
			InsBufLine(hbuf, ln + 1, "��������: @szFuncName@")
			InsBufLine(hbuf, ln + 2, "����˵��: ��")
			InsBufLine(hbuf, ln + 3, "�������: ��")
			InsBufLine(hbuf, ln + 4, "�������: ��")
			InsBufLine(hbuf, ln + 5, "�� �� ֵ:")
			InsBufLine(hbuf, ln + 6, "    >=0: �ɹ�")
			InsBufLine(hbuf, ln + 7, "    < 0: �������")
			sz = cat("��    ��: ", userInfo.authorCh)
			InsBufLine(hbuf, ln + 8, sz)
			sz = cat("�޸�ʱ��: ", GetCurDateCh(GetSysTime(0)))
			InsBufLine(hbuf, ln + 9, sz)
			InsBufLine(hbuf, ln + 10, "˵    ��: ��")
			InsBufLine(hbuf, ln + 11, "*******************************************************************************/")
		}
		
		SetBufIns(hbuf, ln + 12, 0)
	}
}

// ���뺯��ͷ
macro InsertFunctionHeader()
{
	GetAndCheckUserRegInfo()
	
	InsertFuncHeader(GetCurSymbol())
}

// �����µĺ���
macro InsertNewFunction()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		szFuncType = Ask("Please enter the return value type of the function:")
		szFuncName = Ask("Please enter the function name:")
	}
	else
	{
		szFuncType = Ask("�����뺯���ķ���ֵ����:")
		szFuncName = Ask("�����뺯��������:")
	}

	InsertFuncHeader(szFuncName)
	
	hbuf = GetCurrentBuf()
	ln = GetBufLnCur(hbuf)
	
	InsBufLine(hbuf, ln, "@szFuncType@ @szFuncName@()")
	InsBufLine(hbuf, ln + 1, "{")
	InsBufLine(hbuf, ln + 2, "    ")
	InsBufLine(hbuf, ln + 3, "}")

	SetBufIns(hbuf, ln + 2, 4)
}

// ����ǰbuffer�����е�tabת��space
macro TabToSpaceInBuf(hbuf, szTab)
{
	lnMax = GetBufLineCount(hbuf)

	while (lnMax--)
	{
		sz = GetBufLine(hbuf, lnMax)

		szLen = strlen(sz)
		
		szNew = ""
		changed = 0
		j = 0
		while (j < szLen)
		{
			ch = sz[j++]
			if (ch == "	")
			{
				szNew = cat(szNew, szTab)
				changed = 1
			}
			else
			{
				szNew = cat(szNew, ch)
			}
		}

		if (szLen && changed)
		{ // �ַ������Ȳ�Ϊ0���������޸�
			DelBufLine(hbuf, lnMax)
			InsBufLine(hbuf, lnMax, szNew)
		}
	}
}

// �������ļ���tabת��space
macro TabToSpace()
{
	GetAndCheckUserRegInfo()
	
	while (1)
	{
		if (userInfo.language == "English")
		{
			tabNum = Ask("Please enter the SPACE number to replace TAB:")
			if (IsNumber(tabNum))
			{
				break
			}
			Msg("The input should be a number, please re-enter!")
		}
		else
		{
			tabNum = Ask("����һ��tabҪ�滻�Ŀո���Ŀ:")
			if (IsNumber(tabNum))
			{
				break
			}
			Msg("����Ĳ�������, ����������!")
		}
	}

	szTab = ""
	while (tabNum--)
	{
		szTab = cat(szTab, " ")
	}
	
	TabToSpaceInBuf(GetCurrentBuf(), szTab)
}

// Inserts "Returns True .. or False..." at the current line
macro ReturnTrueOrFalse()
{
	hbuf = GetCurrentBuf()
	ln = GetBufLineCur(hbuf)

	InsBufLine(hbuf, ln, "    Returns True if successful or False if errors.")
}

/* Inserts ifdef REVIEW around the selection */
macro IfdefReview()
{
	IfdefSz("REVIEW")
}

/* Inserts ifdef BOGUS around the selection */
macro IfdefBogus()
{
	IfdefSz("BOGUS")
}

/* Inserts ifdef NEVER around the selection */
macro IfdefNever()
{
	IfdefSz("NEVER")
}

// ����#Ifdef
macro InsertIfdef()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		sz = Ask("Enter the condition of #ifdef:")
	}
	else
	{
		sz = Ask("������#ifdef������:")
	}
	
	IfdefSz(sz)
}

// ��ѡ�������ͷβ����#ifndef #define #endif��
macro InsertIfndef()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		sz = Ask("Enter the condition of #ifndef:")
	}
	else
	{
		sz = Ask("������#ifndef������:")
	}
	
	if (sz != "")
	{
		hwnd = GetCurrentWnd()
		lnFirst = GetWndSelLnFirst(hwnd)
		lnLast = GetWndSelLnLast(hwnd)
		 
		hbuf = GetCurrentBuf()
		InsBufLine(hbuf, lnFirst+0, "#ifndef @sz@")
		InsBufLine(hbuf, lnFirst+1, "#define @sz@")
		InsBufLine(hbuf, lnLast+3, "#endif")
		SetBufIns(hbuf, lnFirst+2, 0)
	}
}

macro InsertCPlusPlus()
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#ifdef __cplusplus")
	InsBufLine(hbuf, lnFirst+1, "extern \"C\" {")
	InsBufLine(hbuf, lnFirst+2, "#endif")
	
	InsBufLine(hbuf, lnLast+4, "#ifdef __cplusplus")
	InsBufLine(hbuf, lnLast+5, "}")
	InsBufLine(hbuf, lnLast+6, "#endif")
	
	SetBufIns(hbuf, lnFirst+3, 0)
}


// ��ѡ�������ͷβ����#ifdef #endif��
macro IfdefSz(sz)
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#ifdef @sz@")
	InsBufLine(hbuf, lnLast+2, "#endif")
	SetBufIns(hbuf, lnFirst+1, 0)
}


// Delete the current line and appends it to the clipboard buffer
macro KillLine()
{
	hbufCur = GetCurrentBuf()
	lnCur = GetBufLnCur(hbufCur)
	hbufClip = GetBufHandle("Clipboard")
	AppendBufLine(hbufClip, GetBufLine(hbufCur, lnCur))
	DelBufLine(hbufCur, lnCur)
}


// Paste lines killed with KillLine (clipboard is emptied)
macro PasteKillLine()
{
	Paste
	EmptyBuf(GetBufHandle("Clipboard"))
}


// delete all lines in the buffer
macro EmptyBuf(hbuf)
{
	lnMax = GetBufLineCount(hbuf)
	while (lnMax > 0)
	{
		DelBufLine(hbuf, 0)
		lnMax = lnMax - 1
	}
}

// Ask the user for a symbol name, then jump to its declaration
macro JumpAnywhere()
{
	symbol = Ask("What declaration would you like to see?")
	JumpToSymbolDef(symbol)
}

	
// list all siblings of a user specified symbol
// A sibling is any other symbol declared in the same file.
macro OutputSiblingSymbols()
{
	symbol = Ask("What symbol would you like to list siblings for?")
	hbuf = ListAllSiblings(symbol)
	SetCurrentBuf(hbuf)
}


// Given a symbol name, open the file its declared in and 
// create a new output buffer listing all of the symbols declared
// in that file.  Returns the new buffer handle.
macro ListAllSiblings(symbol)
{
	loc = GetSymbolLocation(symbol)
	if (loc == "")
	{
		msg ("@symbol@ not found.")
		stop
	}
	
	hbufOutput = NewBuf("Results")
	
	hbuf = OpenBuf(loc.file)
	if (hbuf == 0)
	{
		msg ("Can't open file.")
		stop
	}
		
	isymMax = GetBufSymCount(hbuf)
	isym = 0;
	while (isym < isymMax)
	{
		AppendBufLine(hbufOutput, GetBufSymName(hbuf, isym))
		isym = isym + 1
	}

	CloseBuf(hbuf)
	
	return hbufOutput
}

macro InsertFunctionList()
{
	hbuf = GetCurrentBuf()
	ln = GetBufLnCur(hbuf)    // ��ǰ�к�
	lnMax = GetBufLineCount(hbuf)  // ����к�
	oldSymb = ""
	oldSymb = ""

	while (lnMax > 0)
	{
		lnMax = lnMax - 1
		
		sz = GetBufLine(hbuf, lnMax)
		
		szLen = strlen(sz)
		if (szLen > 6)
		{
			szSkip = strmid(sz, 0, 6)
			szSkip = toupper(szSkip)
		}
		else
		{
			szSkip = ""
		}

		if ((szLen == 0) || (sz[0] == "#") || (szSkip == "EXTERN"))
		{ // �������ֵ�, ��#��ͷ������EXTERN��ͷ���ַ���
			continue
		}

		SetBufIns(hbuf, lnMax, 0)
		symb = GetCurSymbol()
		if (symb == "")
		{
			continue
		}
		
		if (symb != oldSymb)
		{
			if (symb != oldSymb1)
			{
				InsBufLine(hbuf, ln, symb)
				oldSymb1 = oldSymb
				lnMax = lnMax + 1 // ���¼��һ�鵱ǰ��һ��, ��Ϊǰ�������һ��
			}

			oldSymb = symb
		}
	}
}

macro TrimRightSpace()
{
	hbuf = GetCurrentBuf()
	lnMax = GetBufLineCount(hbuf)  // ����к�

	while (lnMax > 0)
	{
		lnMax = lnMax - 1
		
		sz = GetBufLine(hbuf, lnMax)
		
		szLen = strlen(sz)
		if (szLen == 0)
		{
			continue
		}

		idx = szLen
		while (idx > 0)
		{
			idx = idx - 1
			if ((sz[idx] != " ") && (sz[idx] != "\t"))
			{
				break
			}
		}

		if ((idx == 0) && ((sz[0] == " ") || (sz[0] == "\t")))
		{ // ��ǰ���ǿ���
			sz = ""
		}
		else if (idx == (szLen - 1))
		{ // ��ǰ������޿ո��tab
			continue
		}
		else
		{ // �пո��tab, ������е�
			sz = strmid(sz, 0, idx + 1)
		}

		DelBufLine(hbuf, lnMax)     // ɾ����һ��
		InsBufLine(hbuf, lnMax, sz) // ���²����µ����ݵ���һ��
	}
}

// ��//ע�͸ĳ�/**/ע��
macro ConvertComment()
{
	hbuf = GetCurrentBuf()
	lnMax = GetBufLineCount(hbuf)  // ����к�

	while (lnMax > 0)
	{
		lnMax = lnMax - 1
		
		sz = GetBufLine(hbuf, lnMax)
		
		szLen = strlen(sz)
		if (szLen == 0)
		{
			continue
		}

		idx = 0
		while (idx < (szLen - 1))
		{
			if ((sz[idx] == "/") && (sz[idx+1] == "/"))
			{
				break
			}
			
			idx = idx + 1
		}

		if (idx == (szLen - 1))
		{ // û���ҵ�//ע��
			continue
		}

		sz[idx + 1] = "*"
		sz = cat(sz, " */")


		DelBufLine(hbuf, lnMax)     // ɾ����һ��
		InsBufLine(hbuf, lnMax, sz) // ���²����µ����ݵ���һ��
	}
}

