/* 
  Utils.em - a small collection of useful editing macros 
  曾华荣 zeng_hr@163.com 最后修改于2009年7月5日
*/

// 获取用户注册信息
macro GetUserRegInfo()
{
	global userInfo

	if (userInfo == nil)
	{
		userInfo.language = getreg(USER_LANGUAGE) // 获取语言
		userInfo.authorEn = getreg(USER_AUTHOR_EN) // 获取作者英文姓名
		userInfo.companyEn = getreg(USER_COMPANY_EN) // 获取作者英文公司名称
		userInfo.authorCh = getreg(USER_AUTHOR_CH) // 获取作者中文姓名
		userInfo.companyCh = getreg(USER_COMPANY_CH) // 获取作者中文公司名称
	}
	
	//Msg(userInfo.language)
	//Msg(userInfo.authorEn)
	//Msg(userInfo.companyEn)
	//Msg(userInfo.authorCh)
	//Msg(userInfo.companyCh)
}

// 改变用户注册信息
macro ChangeUserInfo()
{
	GetUserRegInfo()
	
	while (1)
	{ // 输入作者想要的语言
		language = Ask("Please input your favorate language, 0 for English, other number for Chinese:")
		if (IsNumber(language))
		{ // 是数字
			if (language == 0)
			{
				SetReg(USER_LANGUAGE, "English")
				userInfo.language = "English"
			}
			else
			{
				SetReg(USER_LANGUAGE, "中文")
				userInfo.language = "中文"
			}
			break;
		}
		else
		{ // 不是数字
			//Beep()
			Msg("The input should be a number!")
		}
	}

	if (userInfo.language == "English")
	{ // 英文
		// 输入作者的姓名
		userInfo.authorEn = Ask("Please input author name:")
		SetReg(USER_AUTHOR_EN, userInfo.authorEn)
		
		// 输入公司名称
		userInfo.companyEn = Ask("Please input company name:")
		SetReg(USER_COMPANY_EN, userInfo.companyEn)
	}
	else
	{ // 中文
		// 输入作者的姓名
		userInfo.authorCh = Ask("请输入作者姓名:")
		SetReg(USER_AUTHOR_CH, userInfo.authorCh)
		
		// 输入公司名称
		userInfo.companyCh = Ask("请输入公司名称:")
		SetReg(USER_COMPANY_CH, userInfo.companyCh)
	}
}

// 检查用户注册信息完整性
macro GetAndCheckUserRegInfo()
{
	GetUserRegInfo()

	if ((strlen(userInfo.language) == 0) // 没有设置语言或者不合法
		|| ((userInfo.language == "English") && (!strlen(userInfo.authorEn) || !strlen(userInfo.companyEn))) // 英文信息不全
		|| ((userInfo.language != "English") && (!strlen(userInfo.authorCh) || !strlen(userInfo.companyCh))) // 中文信息不全
		)
	{
		ChangeUserInfo()
	}
}

// 插入英文文件头
macro InsertFileHeaderEn()
{
	szSysTime = GetSysTime(0) // 当前系统时间
	szDueYear = szSysTime.year+3 // 版权到期年
	
	hbuf = GetCurrentBuf()

	sz = GetBufName(hbuf) // 获取文件名
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
	InsBufLine(hbuf, 2, sz) // 插入版权信息

	InsBufLine(hbuf, 3, "********************************************************************************")
	
	sz = "File Name: "
	sz = cat(sz, szFileName)
	InsBufLine(hbuf, 4, sz) // 插入文件名
	
	sz = "Author   : "
	sz = cat(sz, userInfo.authorEn)
	InsBufLine(hbuf, 5, sz) // 插入作者
	
	InsBufLine(hbuf, 6, "Version  : 1.00") // 插入版本信息
	
	sz = "Date     : "
	sz = cat(sz, GetCurDateEn(szSysTime))
	InsBufLine(hbuf, 7, sz) // 插入创建日期
	
	InsBufLine(hbuf, 8, "Description: ")
	InsBufLine(hbuf, 9, "Function List: ")
	InsBufLine(hbuf, 10, "    1. ...: ")
	InsBufLine(hbuf, 11, "History: ")
	
	sz = cat("    Version: 1.00  Author: ", userInfo.authorEn)
	sz = cat(sz, "  Date: ")
	sz = cat(sz, GetCurDateEn(szSysTime))
	InsBufLine(hbuf, 12,  sz) // 插入修改历史
	
	InsBufLine(hbuf, 13, "--------------------------------------------------------------------------------")
	InsBufLine(hbuf, 14, "    1. Primary version")
	InsBufLine(hbuf, 15, "*******************************************************************************/")

	SetBufIns(hbuf, 8, 10)
}

// 插入中文文件头
macro InsertFileHeaderCh()
{
	szSysTime = GetSysTime(0) // 当前系统时间
	szDueYear = szSysTime.year+3 // 版权到期年
	
	hbuf = GetCurrentBuf()

	sz = GetBufName(hbuf) // 获取文件名
	len = strlen(sz)
	while(strmid(sz, len - 1, len) != "\\")
	{
		len = len -1
	}
	szFileName = toupper(strmid(sz, len, strlen(sz)))
	
	InsBufLine(hbuf, 0, "/*******************************************************************************")
	InsBufLine(hbuf, 1, "")
	
	sz = "            版权所有(C), "
	sz = cat(sz, szSysTime.year)
	sz = cat(sz, "~")
	sz = cat(sz, szSysTime.year+3)
	sz = cat(sz, ", ")
	sz = cat(sz, userInfo.companyCh)
	InsBufLine(hbuf, 2, sz) // 插入版权信息

	InsBufLine(hbuf, 3, "********************************************************************************")
	
	sz = "文 件 名: "
	sz = cat(sz, szFileName)
	InsBufLine(hbuf, 4, sz) // 插入文件名
	
	sz = "作    者: "
	sz = cat(sz, userInfo.authorCh)
	InsBufLine(hbuf, 5, sz) // 插入作者
	
	InsBufLine(hbuf, 6, "版    本: 1.00") // 插入版本信息
	
	sz = "日    期: "
	sz = cat(sz, GetCurDateCh(szSysTime))
	InsBufLine(hbuf, 7, sz) // 插入创建日期
	
	InsBufLine(hbuf, 8, "功能描述: ")
	InsBufLine(hbuf, 9, "函数列表: ")
	InsBufLine(hbuf, 10, "    1. ...: ")
	InsBufLine(hbuf, 11, "修改历史: ")
	
	sz = cat("    版本：1.00  作者: ", userInfo.authorCh)
	sz = cat(sz, "  日期: ")
	sz = cat(sz, GetCurDateCh(szSysTime))
	InsBufLine(hbuf, 12,  sz) // 插入修改历史
	
	InsBufLine(hbuf, 13, "--------------------------------------------------------------------------------")
	InsBufLine(hbuf, 14, "    1. 初始版本")
	InsBufLine(hbuf, 15, "*******************************************************************************/")

	SetBufIns(hbuf, 8, 10)
}

// 插入文件头
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
		sz = cat("    版本：1.00  作者: ", userInfo.authorCh)
		sz = cat(sz, "  日期: ")
		sz = cat(sz, GetCurDateCh(GetSysTime(0)))
	}
	
	ln = GetBufLnCur(hbuf)
	InsBufLine(hbuf, ln, sz)
	InsBufLine(hbuf, ln + 1, "--------------------------------------------------------------------------------")
	InsBufLine(hbuf, ln + 2, "    1. ")
	SetBufIns(hbuf, ln + 2, 7)
}

// 获取当前的英文日期信息
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

// 获取当前的中文日期信息
macro GetCurDateCh(szSysTime)
{
	sz = ""
	sz = cat(sz, szSysTime.year)
	sz = cat(sz, "年")
	sz = cat(sz, szSysTime.month)
	sz = cat(sz, "月")
	sz = cat(sz, szSysTime.day)
	sz = cat(sz, "日")
	return sz
}

// 插入结构体
macro InsertStruct()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		szStructName = Ask("Please enter the StructType name:")
	}
	else
	{
		szStructName = Ask("请输入结构体的名称:")
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

// 插入联合体
macro InsertUnion()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		szUnionName = Ask("Please enter the UnionType name:")
	}
	else
	{
		szUnionName = Ask("请输入联合体的名称:")
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

// 插入类
macro InsertClass()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		szClassName = Ask("Please enter the class name:")
	}
	else
	{
		szClassName = Ask("请输入类的名称:")
	}
	
	hbuf = GetCurrentBuf()
	ln = GetBufLnCur(hbuf)
	
	InsBufLine(hbuf, ln, "class @szClassName@")
	InsBufLine(hbuf, ln + 1, "{")
	InsBufLine(hbuf, ln + 2, "    ")
	InsBufLine(hbuf, ln + 3, "};")
	SetBufIns(hbuf, ln + 2, 5)
}

// 插入枚举
macro InsertEnum()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		szEnumName = Ask("Please enter the enum name:")
	}
	else
	{
		szEnumName = Ask("请输入枚举体的名称:")
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

// 插入函数头
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
			InsBufLine(hbuf, ln + 1, "函数名称: @szFuncName@")
			InsBufLine(hbuf, ln + 2, "功能说明: 无")
			InsBufLine(hbuf, ln + 3, "输入参数: 无")
			InsBufLine(hbuf, ln + 4, "输出参数: 无")
			InsBufLine(hbuf, ln + 5, "返 回 值:")
			InsBufLine(hbuf, ln + 6, "    >=0: 成功")
			InsBufLine(hbuf, ln + 7, "    < 0: 错误代码")
			sz = cat("作    者: ", userInfo.authorCh)
			InsBufLine(hbuf, ln + 8, sz)
			sz = cat("修改时间: ", GetCurDateCh(GetSysTime(0)))
			InsBufLine(hbuf, ln + 9, sz)
			InsBufLine(hbuf, ln + 10, "说    明: 无")
			InsBufLine(hbuf, ln + 11, "*******************************************************************************/")
		}
		
		SetBufIns(hbuf, ln + 12, 0)
	}
}

// 插入函数头
macro InsertFunctionHeader()
{
	GetAndCheckUserRegInfo()
	
	InsertFuncHeader(GetCurSymbol())
}

// 插入新的函数
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
		szFuncType = Ask("请输入函数的返回值类型:")
		szFuncName = Ask("请输入函数的名称:")
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

// 将当前buffer中所有的tab转成space
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
		{ // 字符串长度不为0，并且有修改
			DelBufLine(hbuf, lnMax)
			InsBufLine(hbuf, lnMax, szNew)
		}
	}
}

// 将所有文件的tab转成space
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
			tabNum = Ask("输入一个tab要替换的空格数目:")
			if (IsNumber(tabNum))
			{
				break
			}
			Msg("输入的不是数字, 请重新输入!")
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

// 插入#Ifdef
macro InsertIfdef()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		sz = Ask("Enter the condition of #ifdef:")
	}
	else
	{
		sz = Ask("请输入#ifdef的条件:")
	}
	
	IfdefSz(sz)
}

// 在选定区域的头尾加上#ifndef #define #endif对
macro InsertIfndef()
{
	GetAndCheckUserRegInfo()
	
	if (userInfo.language == "English")
	{
		sz = Ask("Enter the condition of #ifndef:")
	}
	else
	{
		sz = Ask("请输入#ifndef的条件:")
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


// 在选定区域的头尾加上#ifdef #endif对
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
	ln = GetBufLnCur(hbuf)    // 当前行号
	lnMax = GetBufLineCount(hbuf)  // 最大行号
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
		{ // 跳过空字的, 以#开头或者以EXTERN开头的字符串
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
				lnMax = lnMax + 1 // 重新检查一遍当前这一行, 因为前面插入了一行
			}

			oldSymb = symb
		}
	}
}

macro TrimRightSpace()
{
	hbuf = GetCurrentBuf()
	lnMax = GetBufLineCount(hbuf)  // 最大行号

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
		{ // 当前行是空行
			sz = ""
		}
		else if (idx == (szLen - 1))
		{ // 当前行最后无空格或tab
			continue
		}
		else
		{ // 有空格或tab, 将其剪切掉
			sz = strmid(sz, 0, idx + 1)
		}

		DelBufLine(hbuf, lnMax)     // 删除这一行
		InsBufLine(hbuf, lnMax, sz) // 重新插入新的内容到这一行
	}
}

// 将//注释改成/**/注释
macro ConvertComment()
{
	hbuf = GetCurrentBuf()
	lnMax = GetBufLineCount(hbuf)  // 最大行号

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
		{ // 没有找到//注释
			continue
		}

		sz[idx + 1] = "*"
		sz = cat(sz, " */")


		DelBufLine(hbuf, lnMax)     // 删除这一行
		InsBufLine(hbuf, lnMax, sz) // 重新插入新的内容到这一行
	}
}

