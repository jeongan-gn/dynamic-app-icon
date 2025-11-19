package com.jeongan.dynamic_icon_aos

import android.content.ComponentName
import android.content.pm.PackageManager
import android.os.Bundle
import android.view.Gravity
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.jeongan.dynamic_icon_aos.R

class MainActivity : AppCompatActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 간단한 레이아웃 생성
        val layout = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(40, 40, 40, 40)
            gravity = Gravity.CENTER
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
            )
        }

        // Default Icon 버튼
        val btnDefault = Button(this).apply {
            text = "Default Icon"
            setOnClickListener {
                changeAppIcon("DefaultIconAlias", R.mipmap.mydefaulticon)
            }
        }
        layout.addView(btnDefault)

        // Blue Icon 버튼
        val btnBlue = Button(this).apply {
            text = "Blue Icon"
            setOnClickListener {
                changeAppIcon("BlueIconAlias", R.mipmap.myblueicon)
            }
        }
        layout.addView(btnBlue)

        // Yellow Icon 버튼
        val btnYellow = Button(this).apply {
            text = "Yellow Icon"
            setOnClickListener {
                changeAppIcon("YellowIconAlias", R.mipmap.myyellowicon)
            }
        }
        layout.addView(btnYellow)

        // Red Icon 버튼
        val btnRed = Button(this).apply {
            text = "Red Icon"
            setOnClickListener {
                changeAppIcon("RedIconAlias", R.mipmap.myredicon)
            }
        }
        layout.addView(btnRed)

        setContentView(layout)
    }

    private fun changeAppIcon(targetAlias: String, iconResId: Int) {
        val pm = packageManager

        // 모든 alias 리스트
        val allAliases = listOf(
            "DefaultIconAlias",
            "BlueIconAlias",
            "YellowIconAlias",
            "RedIconAlias"
        )

        // 현재 활성화된 alias 비활성화, 선택한 alias 활성화
        allAliases.forEach { alias ->
            val componentName = ComponentName(
                this,
                "${this.packageName}.${alias}"
            )

            if (alias == targetAlias) {
                // 선택한 alias 활성화
                pm.setComponentEnabledSetting(
                    componentName,
                    PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                    PackageManager.DONT_KILL_APP
                )
            } else {
                // 나머지 alias 비활성화
                pm.setComponentEnabledSetting(
                    componentName,
                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                    PackageManager.DONT_KILL_APP
                )
            }
        }

        // Custom Toast 표시 (선택한 아이콘 포함)
        showCustomToast(targetAlias, iconResId)
    }

    private fun showCustomToast(aliasName: String, iconResId: Int) {
        // 프로그래매틱하게 Toast 레이아웃 생성
        val toastLayout = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            setPadding(24, 16, 24, 16)
            gravity = Gravity.CENTER_VERTICAL
            background = ContextCompat.getDrawable(this@MainActivity,
                android.R.drawable.toast_frame)
        }

        // 아이콘 ImageView
        val iconView = ImageView(this).apply {
            setImageResource(iconResId)
            layoutParams = LinearLayout.LayoutParams(
                48, // width in pixels
                48  // height in pixels
            ).apply {
                marginEnd = 16
            }
        }
        toastLayout.addView(iconView)

        // 텍스트 TextView
        val textView = TextView(this).apply {
            text = "$aliasName 아이콘이 적용되었습니다"
            textSize = 14f
            setTextColor(ContextCompat.getColor(this@MainActivity,
                android.R.color.white))
        }
        toastLayout.addView(textView)

        // Toast 생성 및 표시
        Toast(this).apply {
            duration = Toast.LENGTH_SHORT
            view = toastLayout
            show()
        }
    }
}