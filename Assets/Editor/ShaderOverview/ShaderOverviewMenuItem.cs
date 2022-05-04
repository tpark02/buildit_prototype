using UnityEditor;

public static class ShaderOverviewMenuItem
{
    [MenuItem("Window/Shader Overview")]
    static void ShowWindow()
    {
        var wnd = ShaderOverview.MainWindow.CreateWindow();
        if (wnd != null)
            wnd.Show();
    }
}
