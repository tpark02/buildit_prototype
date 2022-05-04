using UnityEngine;
using UnityEditor;

public static class ExportPackage
{
    [MenuItem("Export/Export with tags and layers, Input settings")]
    public static void export()
    {
        //string[] projectContent = new string[] { "Assets", "ProjectSettings/TagManager.asset", "ProjectSettings/InputManager.asset", "ProjectSettings/ProjectSettings.asset" };
        string[] projectContent = new string[] { "Assets/Scenes" };
        AssetDatabase.ExportPackage(projectContent, "Done.unitypackage", ExportPackageOptions.Interactive | ExportPackageOptions.Recurse | ExportPackageOptions.IncludeDependencies);
        Debug.Log("Project Exported");
    }
}