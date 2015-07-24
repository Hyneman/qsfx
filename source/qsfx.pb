; ////
; //////
; ////// ===============================
; //////     Q S F X   L I B R A R Y
; ////// ===============================
; //////
; ////// COPYRIGHT © 2015 BY SILENT BYTE.
; ////// ALL RIGHTS RESERVED.
; //////
; ////// REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS, WITH OR WITHOUT MODIFICATION,
; ////// ARE PERMITTED PROVIDED THAT THE FOLLOWING CONDITIONS ARE MET:
; //////
; ////// 1. REDISTRIBUTIONS OF SOURCE CODE MUST RETAIN THE ABOVE COPYRIGHT NOTICE,
; //////    THIS LIST OF CONDITIONS AND THE FOLLOWING DISCLAIMER.
; //////
; ////// 2. REDISTRIBUTIONS IN BINARY FORM MUST REPRODUCE THE ABOVE COPYRIGHT NOTICE,
; //////    THIS LIST OF CONDITIONS AND THE FOLLOWING DISCLAIMER IN THE DOCUMENTATION
; //////    AND/OR OTHER MATERIALS PROVIDED WITH THE DISTRIBUTION.
; //////
; ////// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
; ////// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
; ////// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
; ////// IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
; ////// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
; ////// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
; ////// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
; ////// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ////// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; ////// POSSIBILITY OF SUCH DAMAGE.
; //////
; ////


EnableExplicit


; // region ...Constants...


#QSFX_VERSION_MAJOR = 0
#QSFX_VERSION_MINOR = 1

CompilerIf #PB_Compiler_ExecutableFormat = #PB_Compiler_DLL
	#QSFX_LIBRARY = #True
CompilerElse
	#QSFX_LIBRARY = #False
CompilerEndIf

CompilerIf Not Defined(QSFX_DEBUG, #PB_Constant)
	CompilerIf #PB_Compiler_Debugger
		#QSFX_DEBUG = #True
	CompilerElse
		#QSFX_DEBUG = #False
	CompilerEndIf
CompilerEndIf

CompilerIf Not Defined(QSFX_DEBUG_TRACE, #PB_Constant)
	#QSFX_DEBUG_TRACE = #False
CompilerEndIf

Enumeration
	#QSFX_ERROR_SUCCESSFUL
	#QSFX_ERROR_INITIALIZATION
EndEnumeration


; // end region
; // region ...Structures...


Structure QSFX_GLOBAL
	initialized.i
	error.i
EndStructure

Structure QSFX_VERSION
	major.a
	minor.a
EndStructure


; // end region
; // region ...Macros...


Macro QSFX_DEBUG(__message)
	CompilerIf #QSFX_DEBUG
		CompilerIf #QSFX_DEBUG_TRACE
			Debug "[" + GetFilePart(#PB_Compiler_File, #PB_FileSystem_NoExtension) + "," + #PB_Compiler_Line + "] " + __message
			PrintN("[" + GetFilePart(#PB_Compiler_File, #PB_FileSystem_NoExtension) + "," + #PB_Compiler_Line + "] " + __message)
		CompilerElse
			Debug "[QSFX] " + __message
			PrintN("[QSFX] " + __message)
		CompilerEndIf
	CompilerEndIf
EndMacro


; // end region
; // region ...Globals...


Global qsfx.QSFX_GLOBAL

With qsfx
	\initialized = #False
	\error = #QSFX_ERROR_SUCCESSFUL
EndWith


; // end region
; // region ...Locals...


Procedure.i qsfx_set_error(error.i)
	qsfx\error = error
	ProcedureReturn #True
EndProcedure


; // end region
; // region ...Exports...


ProcedureDLL.i qsfx_version(*version.QSFX_VERSION)
	If Not *version
		ProcedureReturn #False
	EndIf

	With *version
		\major = #QSFX_VERSION_MAJOR
		\minor = #QSFX_VERSION_MINOR
	EndWith

	ProcedureReturn #True
EndProcedure

ProcedureDLL.i qsfx_error()
	ProcedureReturn qsfx\error
EndProcedure

ProcedureDLL.i qsfx_initialize()
	CompilerIf #QSFX_DEBUG And Not #QSFX_LIBRARY
		OpenConsole()
	CompilerEndIf

	UseOGGSoundDecoder()
	UseFLACSoundDecoder()

	If Not qsfx\initialized
		If Not InitSound()
			QSFX_DEBUG("Could not initialize sound devices.")
			qsfx_set_error(#QSFX_ERROR_INITIALIZATION)
			ProcedureReturn #False
		EndIf

		qsfx\initialized = #True
	EndIf

	QSFX_DEBUG("QSFX initialized successfully.")
	ProcedureReturn #True
EndProcedure


; // end region


