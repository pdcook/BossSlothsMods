﻿using System.Collections.Generic;
using HarmonyLib;
using UnityEngine;

namespace BossSlothsCards.Patches
{
    public class ResetPatch
    {
        [HarmonyPatch(typeof(Player),"FullReset")]
        private class Patch_blocked
        {
            // ReSharper disable once UnusedMember.Local
            private static void Postfix(Player __instance)
            {
                foreach (var resetObj in __instance.GetComponents<BossSlothMonoBehaviour>())
                {
                    Object.Destroy(resetObj);
                }
                __instance.data.currentCards = new List<CardInfo> { };
            }
        }
    }
}