package com.actionsprout.snagbug

class FromDartThrowable constructor(
        private var errorClass: String?,
        private var errorMessage: String?,
        private var frames: ArrayList<*>
) : Throwable() {
    override val message: String?
        get() = errorMessage

    override fun getLocalizedMessage(): String {
        return errorMessage.orEmpty()
    }

    override val cause: Throwable?
        get() = null

    override fun getStackTrace(): Array<StackTraceElement> {
        return frames.map {
            val frame = it as HashMap<String, Any>
            StackTraceElement("", frame["member"] as String, frame["file"] as String, frame["line"] as Int)
        }.toTypedArray<StackTraceElement>()
    }
}